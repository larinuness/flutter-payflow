import 'package:flutter/material.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import '../divider/divider_vertical.dart';
import '../label_button/label_button.dart';

class SetLabelButtons extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback primaryOnPressed;
  final String secondaryLabel;
  final VoidCallback secondaryOnPressed;
  final bool enablePrimaryColor;
  final bool enableSecundaryColor;
  const SetLabelButtons(
      {Key? key,
      required this.primaryLabel,
      required this.primaryOnPressed,
      required this.secondaryLabel,
      required this.secondaryOnPressed,
      this.enablePrimaryColor = false,
      this.enableSecundaryColor = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      height: 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            thickness: 1,
            height: 1,
            color: AppColors.stroke,
          ),
          SizedBox(
            height: 56,
            child: Row(
              children: [
                Expanded(
                  child: LabelButton(
                      label: primaryLabel,
                      onPressed: primaryOnPressed,
                      style:
                          enablePrimaryColor ? TextStyles.buttonPrimary : null),
                ),
                const DividerVertical(),
                Expanded(
                  child: LabelButton(
                      label: secondaryLabel,
                      onPressed: secondaryOnPressed,
                      style: enableSecundaryColor
                          ? TextStyles.buttonPrimary
                          : null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
