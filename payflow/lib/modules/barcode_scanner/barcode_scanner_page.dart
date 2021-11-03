import 'package:flutter/material.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_controller.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_status.dart';

import '../../shared/themes/app_text_styles.dart';
import '../../shared/widgets/bottom_sheet/bottom_sheet.dart';
import '../../shared/widgets/set_label_buttons/set_label_buttons.dart';

//armazenar as var ver os estado, se vai pode utilizar a camera ou não
class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final controller = BarcodeScannerController();
  //chamar o processo anters de renderizar na tela
  @override
  void initState() {
    controller.getAvailableCameras();
    controller.statusNotifier.addListener(() {
      if (controller.status.hasBarcode) {
        Navigator.pushReplacementNamed(context, "/insert_boleto",
            arguments: controller.status.barcode);
      }
    });

    super.initState();
  }

  //fecha depois que finaliza o processo
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      left: true,
      right: true,
      child: Stack(
        children: [
          ValueListenableBuilder<BarcodeScannerStatus>(
              valueListenable: controller.statusNotifier,
              builder: (_, status, __) {
                if (status.showCamera) {
                  return Container(
                    color: Colors.blue,
                    child: controller.cameraController!.buildPreview(),
                  );
                } else {
                  return Container();
                }
              }),
          //widget de girar a tela
          //quarterTurns 1 quer dizer que vai dar um giro
          RotatedBox(
            quarterTurns: 1,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  centerTitle: true,
                  title: Text(
                    "Escaneie o código de barras do boleto",
                    style: TextStyles.buttonBackground,
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                bottomNavigationBar: SetLabelButtons(
                  primaryLabel: "Inserir código do boleto",
                  primaryOnPressed: () {
                    controller.status = BarcodeScannerStatus.error("Error");
                  },
                  secondaryLabel: "Adicionar da galeria",
                  secondaryOnPressed: controller.scanWithImagePicker,
                )),
          ),
          ValueListenableBuilder<BarcodeScannerStatus>(
              valueListenable: controller.statusNotifier,
              builder: (_, status, __) {
                if (status.hasError) {
                  return Align(
                      alignment: Alignment.bottomLeft,
                      child: BottomSheetWidget(
                          primaryLabel: "Escanear novamente",
                          primaryOnPressed: () {
                            controller.scanWithCamera();
                          },
                          secondaryLabel: "Digitar código",
                          secondaryOnPressed: () {},
                          title:
                              "Não foi possível identificar um código de barras.",
                          subTitle:
                              "Tente escanear novamente ou digite o código do seu boleto."));
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }
}
