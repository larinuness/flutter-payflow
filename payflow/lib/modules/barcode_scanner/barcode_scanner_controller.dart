import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import 'barcode_scanner_status.dart';

class BarcodeScannerController {
  //ValueNotifier é um gerenciador de estados
  //sempre que tiver alteração, passa pra view
  final statusNotifier =
      ValueNotifier<BarcodeScannerStatus>(BarcodeScannerStatus());
  BarcodeScannerStatus get status => statusNotifier.value;
  set status(BarcodeScannerStatus status) => statusNotifier.value = status;

  var barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  CameraController? cameraController;

  InputImage? imagePicker;
  //function pra saber se tem camera
  void getAvailableCameras() async {
    try {
      //saber se o dispositivo tem camera traseira
      //firstWhere porque o dispositivo pode ter varias cameras
      //ele vai pegar a primeira camera de tras se tiver varias
      final response = await availableCameras();
      final camera = response.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.back);
      cameraController =
          CameraController(camera, ResolutionPreset.max, enableAudio: false);
      //inicia a camera
      await cameraController!.initialize();
      scanWithCamera();
      listenCamera();
    } catch (e) {
      status = BarcodeScannerStatus.error(e.toString());
    }
  }

  //verifica se o controll é diferente de null
  //quando encontra imagem pausa e faz a leitura dela
  Future<void> scannerBarCode(InputImage inputImage) async {
    try {
      final barcodes = await barcodeScanner.processImage(inputImage);

      String? barcode;
      //se tiver barcode salva na var
      for (Barcode item in barcodes) {
        barcode = item.value.displayValue;
      }
      //se não for nullo e vazio, atualiza o status do barcode
      //fecha a camera e vai pra tela de preenche o resto do boleto
      //se não reinicia o processo e chama a camera de novo
      if (barcode != null && status.barcode.isEmpty) {
        status = BarcodeScannerStatus.barcode(barcode);
        cameraController!.dispose();
        await barcodeScanner.close();
      }

      return;
    } catch (e) {
      // ignore: avoid_print
      print("ERRO DA LEITURA $e");
    }
  }

  void scanWithImagePicker() async {
    // ignore: deprecated_member_use
    final response = await ImagePicker().getImage(source: ImageSource.gallery);
    final inputImage = InputImage.fromFilePath(response!.path);
    scannerBarCode(inputImage);
  }

  void scanWithCamera() {
    status = BarcodeScannerStatus.available();
    Future.delayed(const Duration(seconds: 20)).then((value) {
      if (status.hasBarcode == false) {
        status = BarcodeScannerStatus.error("Timeout de leitura de boleto");
      }
    });
  }

  //ouvir a img que vem da camera
  void listenCamera() {
    //checa se tem alguem ouvindo a camera
    if (cameraController!.value.isStreamingImages == false) {
      //converte em um inputImageCamera
      cameraController!.startImageStream((cameraImage) async {
        if (status.stopScanner == false) {
          try {
            final WriteBuffer allBytes = WriteBuffer();
            for (Plane plane in cameraImage.planes) {
              allBytes.putUint8List(plane.bytes);
            }
            final bytes = allBytes.done().buffer.asUint8List();
            final Size imageSize = Size(
                cameraImage.width.toDouble(), cameraImage.height.toDouble());
            const InputImageRotation imageRotation =
                InputImageRotation.Rotation_0deg;
            final InputImageFormat inputImageFormat =
                InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ??
                    InputImageFormat.NV21;
            final planeData = cameraImage.planes.map(
              (Plane plane) {
                return InputImagePlaneMetadata(
                  bytesPerRow: plane.bytesPerRow,
                  height: plane.height,
                  width: plane.width,
                );
              },
            ).toList();

            final inputImageData = InputImageData(
              size: imageSize,
              imageRotation: imageRotation,
              inputImageFormat: inputImageFormat,
              planeData: planeData,
            );
            final inputImageCamera = InputImage.fromBytes(
                bytes: bytes, inputImageData: inputImageData);
            scannerBarCode(inputImageCamera);
          } catch (e) {
            // ignore: avoid_print
            print(e);
          }
        }
      });
    }
  }

  //finaliza os processos
  //todo mundo que ouve ele tbm
  void dispose() {
    statusNotifier.dispose();
    barcodeScanner.close();
    if (status.showCamera) {
      cameraController!.dispose();
    }
  }
}
