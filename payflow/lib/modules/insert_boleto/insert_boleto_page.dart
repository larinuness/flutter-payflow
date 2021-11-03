import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/input_text/input_text.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

import 'insert_boleto_controller.dart';

class InsertBoletoPage extends StatefulWidget {
  final String? barcode;
  const InsertBoletoPage({
    Key? key,
    this.barcode,
  }) : super(key: key);

  @override
  State<InsertBoletoPage> createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  final controller = InsertBoletoController();

  final moneyInputTextController =
      MoneyMaskedTextController(leftSymbol: "R\$", decimalSeparator: ",");
  final dueDateInputTextController = MaskedTextController(mask: "00/00/0000");
  final barcodeInputTextController = TextEditingController();

  @override
  void initState() {
    //quando ler o leitor ja aparece o código no field
    if (widget.barcode != null) {
      barcodeInputTextController.text = widget.barcode!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.input),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 93, vertical: 20),
              child: Text(
                'Preencha os dados do boleto',
                style: TextStyles.titleBoldHeading,
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  InputTextWidget(
                    label: 'Nome do boleto',
                    icon: Icons.description_outlined,
                    onChanged: (value) {},
                    validator: controller.validateName,
                  ),
                  InputTextWidget(
                    controller: dueDateInputTextController,
                    label: 'Vencimento',
                    icon: FontAwesomeIcons.timesCircle,
                    onChanged: (value) {},
                    validator: controller.validateVencimento,
                  ),
                  InputTextWidget(
                    label: 'Valor',
                    icon: FontAwesomeIcons.wallet,
                    onChanged: (value) {},
                    validator: (_) => controller
                        .validateValor(moneyInputTextController.numberValue),
                  ),
                  InputTextWidget(
                    controller: barcodeInputTextController,
                    label: 'Código',
                    icon: FontAwesomeIcons.barcode,
                    onChanged: (value) {},
                    validator: controller.validateCodigo,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SetLabelButtons(
        enableSecundaryColor: true,
        primaryLabel: 'Cancelar',
        primaryOnPressed: () {
          //volta pra tela anterior
          Navigator.pop(context);
        },
        secondaryLabel: 'Cadastrar',
        secondaryOnPressed: () {},
      ),
    );
  }
}
