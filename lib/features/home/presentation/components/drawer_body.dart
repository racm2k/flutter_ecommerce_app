import 'package:app/core/constants/application_constants.dart';
import 'package:app/core/data/models/user_model.dart';
import 'package:app/core/navigator/application_routes.dart';
import 'package:flutter/material.dart';

import 'menu_item_component.dart';

class DrawerBody extends StatelessWidget {
  final UserModel? user;
  final VoidCallback onSignOutConfirm;
  const DrawerBody({
    required this.user,
    required this.onSignOutConfirm,
    Key? key,
  }) : super(key: key);

  final bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 36),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: user?.imageUrl!=null,
                    child: CircleAvatar(
                      foregroundImage: NetworkImage(user?.imageUrl ?? ''),
                      radius: 25,
                      child: Text(
                        user?.name?.substring(0, 1) ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user?.name ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: user?.email!='',
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                user?.email ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MenuItem(
                    onPressed: () {
                      Navigator.of(context)
                          .popAndPushNamed(ApplicationRoutes.ordersScreen);
                    },
                    icon: const Icon(
                      Icons.shopping_bag,
                      color: Colors.black54,
                    ),
                    title: 'Encomendas',
                  ),
                  MenuItem(
                    icon: const Icon(
                      Icons.contact_page,
                    ),
                    title: 'Contatos',
                    onPressed: () {
                      Navigator.of(context)
                          .popAndPushNamed(ApplicationRoutes.contactsScreen);
                    },
                  ),
                  MenuItem(
                    onPressed: () {
                      Navigator.of(context)
                          .popAndPushNamed(ApplicationRoutes.aboutUsScreen);
                    },
                    icon: const Icon(
                      Icons.people_sharp,
                      color: Colors.black54,
                    ),
                    title: 'Sobre Nós',
                  ),
                  Visibility(
                    visible: visible,
                    child: MenuItem(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black54,
                      ),
                      title: 'Definições',
                    ),
                  ),
                  MenuItem(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                            title: const Text(
                              'Terminar Sessão',
                              style: TextStyle(color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                            content: const Text(
                              'Tem a certeza que deseja terminar a sessão?',
                              style: TextStyle(color: Colors.black54),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Não',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              TextButton(
                                  onPressed: onSignOutConfirm,
                                  child: const Text(
                                    'Sim',
                                    style: TextStyle(color: Colors.redAccent),
                                  )),
                            ],
                          );
                        }),
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.black54,
                    ),
                    title: 'Terminar Sessão',
                  ),
                ],
              )
            ],
          ),
          const Positioned(
            bottom: 0,
            left: 16,
            child: Text(
              'Garbo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }
}
