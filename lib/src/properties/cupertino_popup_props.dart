import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CupertinoMultiSelectionPopupProps<T> extends BasePopupProps<T> {
  ///dialog mode props
  final CupertinoDialogProps dialogProps;

  ///BottomSheet mode props
  final CupertinoBottomSheetProps bottomSheetProps;

  ///ModalBottomSheet mode props
  final CupertinoModalBottomSheetProps modalBottomSheetProps;

  ///Menu mode props
  final CupertinoMenuProps menuProps;

  ///Menu mode props
  final CupertinoAutocompleteProps autoCompleteProps;

  const CupertinoMultiSelectionPopupProps.menu({
    this.menuProps = const CupertinoMenuProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : bottomSheetProps = const CupertinoBottomSheetProps(),
        dialogProps = const CupertinoDialogProps(),
        modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
        autoCompleteProps = const CupertinoAutocompleteProps(),
        super(mode: PopupMode.menu, searchFieldProps: searchFieldProps);

  const CupertinoMultiSelectionPopupProps.autocomplete({
    this.autoCompleteProps = const CupertinoAutocompleteProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : bottomSheetProps = const CupertinoBottomSheetProps(),
        dialogProps = const CupertinoDialogProps(),
        modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
        menuProps = const CupertinoMenuProps(),
        super(mode: PopupMode.autocomplete, searchFieldProps: searchFieldProps);

  const CupertinoMultiSelectionPopupProps.dialog({
    this.dialogProps = const CupertinoDialogProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints.tightFor(height: 400),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : bottomSheetProps = const CupertinoBottomSheetProps(),
        menuProps = const CupertinoMenuProps(),
        autoCompleteProps = const CupertinoAutocompleteProps(),
        modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
        super(mode: PopupMode.dialog, searchFieldProps: searchFieldProps);

  const CupertinoMultiSelectionPopupProps.bottomSheet({
    this.bottomSheetProps = const CupertinoBottomSheetProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : menuProps = const CupertinoMenuProps(),
        dialogProps = const CupertinoDialogProps(),
        autoCompleteProps = const CupertinoAutocompleteProps(),
        modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
        super(mode: PopupMode.bottomSheet, searchFieldProps: searchFieldProps);

  const CupertinoMultiSelectionPopupProps.modalBottomSheet({
    this.modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints.tightFor(height: 400),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
    //multi selection props
    super.onItemAdded,
    super.onItemRemoved,
    super.checkBoxBuilder,
    super.validationBuilder,
    super.textDirection = TextDirection.ltr,
  })  : menuProps = const CupertinoMenuProps(),
        bottomSheetProps = const CupertinoBottomSheetProps(),
        autoCompleteProps = const CupertinoAutocompleteProps(),
        dialogProps = const CupertinoDialogProps(),
        super(mode: PopupMode.modalBottomSheet, searchFieldProps: searchFieldProps);
}

class CupertinoPopupProps<T> extends BasePopupProps<T> {
  ///dialog mode props
  final CupertinoDialogProps dialogProps;

  ///BottomSheet mode props
  final CupertinoBottomSheetProps bottomSheetProps;

  ///ModalBottomSheet mode props
  final CupertinoModalBottomSheetProps modalBottomSheetProps;

  ///Menu mode props
  final CupertinoMenuProps menuProps;

  ///Menu mode props
  final CupertinoAutocompleteProps autoCompleteProps;

  const CupertinoPopupProps.menu({
    this.menuProps = const CupertinoMenuProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : bottomSheetProps = const CupertinoBottomSheetProps(),
        dialogProps = const CupertinoDialogProps(),
        modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
        autoCompleteProps = const CupertinoAutocompleteProps(),
        super(mode: PopupMode.menu, searchFieldProps: searchFieldProps);

  const CupertinoPopupProps.autocomplete({
    this.autoCompleteProps = const CupertinoAutocompleteProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 350),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : bottomSheetProps = const CupertinoBottomSheetProps(),
        dialogProps = const CupertinoDialogProps(),
        modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
        menuProps = const CupertinoMenuProps(),
        super(mode: PopupMode.autocomplete, searchFieldProps: searchFieldProps);

  const CupertinoPopupProps.dialog({
    this.dialogProps = const CupertinoDialogProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints.tightFor(height: 400),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : bottomSheetProps = const CupertinoBottomSheetProps(),
        menuProps = const CupertinoMenuProps(),
        autoCompleteProps = const CupertinoAutocompleteProps(),
        modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
        super(mode: PopupMode.dialog, searchFieldProps: searchFieldProps);

  const CupertinoPopupProps.modalBottomSheet({
    this.modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints.tightFor(height: 400),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : menuProps = const CupertinoMenuProps(),
        dialogProps = const CupertinoDialogProps(),
        autoCompleteProps = const CupertinoAutocompleteProps(),
        bottomSheetProps = const CupertinoBottomSheetProps(),
        super(mode: PopupMode.modalBottomSheet, searchFieldProps: searchFieldProps);

  const CupertinoPopupProps.bottomSheet({
    this.bottomSheetProps = const CupertinoBottomSheetProps(),
    CupertinoTextFieldProps searchFieldProps = const CupertinoTextFieldProps(),
    super.fit = FlexFit.tight,
    super.suggestionsProps,
    super.scrollbarProps,
    super.listViewProps,
    super.searchDelay,
    super.itemClickProps,
    super.showSearchBox,
    super.title,
    super.disableFilter,
    super.cacheItems,
    super.itemBuilder,
    super.disabledItemFn,
    super.onDismissed,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
    super.showSelectedItems,
    super.containerBuilder,
    super.constraints = const BoxConstraints(maxHeight: 500),
    super.interceptCallBacks,
    super.infiniteScrollProps,
    super.onItemsLoaded,
  })  : menuProps = const CupertinoMenuProps(),
        modalBottomSheetProps = const CupertinoModalBottomSheetProps(),
        dialogProps = const CupertinoDialogProps(),
        autoCompleteProps = const CupertinoAutocompleteProps(),
        super(mode: PopupMode.bottomSheet, searchFieldProps: searchFieldProps);
}
