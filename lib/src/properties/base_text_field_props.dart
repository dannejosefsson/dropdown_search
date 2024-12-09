import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

abstract class BaseTextFieldProps {
  final TextEditingController? controller;
  final ContainerBuilder? containerBuilder;

  const BaseTextFieldProps({
    this.controller,
    this.containerBuilder,
  });
}
