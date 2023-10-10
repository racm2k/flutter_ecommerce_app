import 'package:app/core/components/custom_scaffold.dart';
import 'package:app/core/constants/application_constants.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        title: 'Sobre Nós',
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                  'https://static.wixstatic.com/media/72faf0cdcc07449cbdf9afbe2cbc79b0.jpg/v1/fill/w_934,h_398,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/72faf0cdcc07449cbdf9afbe2cbc79b0.jpg'),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Garbo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Na GARBO acreditamos que cada equipa tem uma história distinta e por isso uma identidade única.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text(
                'Desta forma trabalhamos na customização do vestuário para que essa identidade seja mantida independentemente do desporto praticado.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text(
                'Na GARBO produzimos roupa desportiva casual e técnica adequada a cada modalidade utilizando as melhores matérias primas aliadas sempre a um design inovador.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text(
                'A nossa equipa existe parta o auxiliar a desenvolver a imagem mantendo a identidade a sua equipa, personalizando as peças através de Sublimação, Transfers, Estampagem ou Bordado.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
