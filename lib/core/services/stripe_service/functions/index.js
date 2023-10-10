const functions = require("firebase-functions");
const stripe = require("stripe")('sk_test_51NvKD1EVsP8g1CYLrRF8jrx9eZLbx9wMwTkZksyZGOv7RRUqPoDaDhZl2vQ1n8OdxprrCVnaSZ92czCquijOjEW000UkYi2aLQ');

const calculateOrderAmount = (items) => {
    var amount = 0.0;
    console.log(items[0]["item"]);
    console.log(items[0]["item"]["price"]);
    console.log(items[0]["quantity"]);

    items.forEach(element => {
        amount += (element["quantity"] * element["item"]["price"]);
    });

    return (amount.toFixed(2) * 100).toFixed(0);
}

const generateResponse = function (intent) {
    switch (intent.status) {
        case "requires-action":
            return {
                clientSecret: intent.clientSecret,
                requiresAction: true,
                status: intent.status,
            };
        case "requires_payment_method":
            return {
                "error": "Your card was denied, please provide a new payment method",
            };
        case "succeeded":
            console.log("Payment succeeded.");
            return { clientSecret: intent.clientSecret, status: intent.status, };
    }
    return { error: "Failed" };
}

exports.StripePayEndpointMethodId = functions.https.onRequest(async (req, res) => {
    const { paymentMethodId, items, currency, useStripeSdk } = req.body;

    const orderAmount = calculateOrderAmount(items);
    try {
        if (paymentMethodId) {
            const params = {
                amount: orderAmount,
                confirm: true,
                currency: currency,
                payment_method: paymentMethodId,
                use_stripe_sdk: useStripeSdk,
                return_url: "https://garbo-store.app.link/EsgxoOvnzDb",
                automatic_payment_methods: {
                    allow_redirects: 'never',
                    enabled: true,
                }
            }
            const intent = await stripe.paymentIntents.create(params);
            console.log("Intent: " + intent);
            return res.send(generateResponse(intent));
        }
    } catch (e) {

    }
});
exports.StripePayEndpointIntentId = functions.https.onRequest(async (req, res) => {
    const { paymentIntentId } = req.body;
    try {
        if (paymentIntentId) {
            const intent = await stripe.paymentIntents.confirm(paymentIntentId);
            return res.send(generateResponse(intent));
        }
        return res.sendStatus(400);
    } catch (e) {
        return res.send({ error: e.message });
    }
});