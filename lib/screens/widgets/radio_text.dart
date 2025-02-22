import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';

class RadioText extends StatefulWidget {
  const RadioText(
      {required this.radioGroup,
      required this.value,
      required this.onChanged,
      required this.selected,
      super.key});

  final ValueChanged<String> onChanged;
  final String radioGroup;
  final String value;
  final bool selected;

  @override
  State<RadioText> createState() => _RadioTextState();
}

class _RadioTextState extends State<RadioText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Radio.adaptive(
                value: widget.value,
                groupValue: widget.radioGroup,
                onChanged: (b) => widget.onChanged(b!)),
            widget.selected
                ? const CircleAvatar(
                    radius: 5,
                    backgroundColor: kPrimaryColor,
                  )
                : Container(),
          ],
        ),
        Text(
          widget.value,
          style: TextStyle(
            fontWeight: widget.selected ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
