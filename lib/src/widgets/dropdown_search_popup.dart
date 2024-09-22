import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/src/widgets/custom_inkwell.dart';
import 'package:dropdown_search/src/widgets/suggestions_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'checkbox_widget.dart';

class DropdownSearchPopup<T> extends StatefulWidget {
  final ValueChanged<List<T>>? onChanged;
  final DropdownSearchOnFind<T>? items;
  final DropdownSearchItemAsString<T>? itemAsString;
  final DropdownSearchFilterFn<T>? filterFn;
  final DropdownSearchCompareFn<T>? compareFn;
  final List<T> defaultSelectedItems;
  final PopupPropsMultiSelection<T> props;
  final bool isMultiSelectionMode;

  const DropdownSearchPopup({
    super.key,
    required this.props,
    this.defaultSelectedItems = const [],
    this.isMultiSelectionMode = false,
    this.onChanged,
    this.items,
    this.itemAsString,
    this.filterFn,
    this.compareFn,
  });

  @override
  DropdownSearchPopupState<T> createState() => DropdownSearchPopupState<T>();
}

class DropdownSearchPopupState<T> extends State<DropdownSearchPopup<T>> {
  final StreamController<List<T>> _itemsStream = StreamController.broadcast();
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier(false);
  final List<T> _cachedItems = [];
  final ValueNotifier<List<T>> _selectedItemsNotifier = ValueNotifier([]);
  final ScrollController scrollController = ScrollController();
  final List<T> _currentShowedItems = [];
  late TextEditingController searchBoxController;
  late bool isInfiniteScrollEnded;

  List<T> get _selectedItems => _selectedItemsNotifier.value;
  Timer? _debounce;
  String lastSearchText = '';

  void searchBoxControllerListener() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    //handle case when editText get focused, onTextChange was called !
    if (lastSearchText == searchBoxController.text) return;

    _debounce = Timer(widget.props.searchDelay, () {
      lastSearchText = searchBoxController.text;
      _manageLoadItems(searchBoxController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier.value = widget.defaultSelectedItems;

    searchBoxController = widget.props.searchFieldProps.controller ?? TextEditingController();
    searchBoxController.addListener(searchBoxControllerListener);

    lastSearchText = searchBoxController.text;

    isInfiniteScrollEnded = widget.props.infiniteScrollProps == null;

    Future.delayed(
      Duration.zero,
      () => _manageLoadItems(searchBoxController.text, isFirstLoad: true),
    );
  }

  @override
  void didUpdateWidget(covariant DropdownSearchPopup<T> oldWidget) {
    if (!listEquals(oldWidget.defaultSelectedItems, widget.defaultSelectedItems)) {
      _selectedItemsNotifier.value = widget.defaultSelectedItems;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _itemsStream.close();
    _debounce?.cancel();

    if (widget.props.searchFieldProps.controller == null) {
      searchBoxController.dispose();
    } else {
      searchBoxController.removeListener(searchBoxControllerListener);
    }

    if (widget.props.listViewProps.controller == null) {
      scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.props.constraints,
      child: widget.props.containerBuilder == null
          ? _defaultWidget()
          : widget.props.containerBuilder!(context, _defaultWidget()),
    );
  }

  Widget _defaultWidget() {
    return Material(
      type: MaterialType.transparency,
      child: ValueListenableBuilder(
          valueListenable: _selectedItemsNotifier,
          builder: (ctx, value, w) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _searchField(),
                _suggestedItemsWidget(),
                Flexible(
                  fit: widget.props.fit,
                  child: Stack(
                    children: <Widget>[
                      StreamBuilder<List<T>>(
                        stream: _itemsStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return _errorWidget(snapshot.error);
                          } else if (!snapshot.hasData) {
                            return _loadingWidget();
                          } else if (snapshot.data!.isEmpty) {
                            return _noDataWidget();
                          }

                          final itemCount = snapshot.data!.length;
                          return RawScrollbar(
                            controller: widget.props.listViewProps.controller ?? scrollController,
                            thumbVisibility: widget.props.scrollbarProps.thumbVisibility,
                            trackVisibility: widget.props.scrollbarProps.trackVisibility,
                            thickness: widget.props.scrollbarProps.thickness,
                            radius: widget.props.scrollbarProps.radius,
                            notificationPredicate: widget.props.scrollbarProps.notificationPredicate,
                            interactive: widget.props.scrollbarProps.interactive,
                            scrollbarOrientation: widget.props.scrollbarProps.scrollbarOrientation,
                            thumbColor: widget.props.scrollbarProps.thumbColor,
                            fadeDuration: widget.props.scrollbarProps.fadeDuration,
                            crossAxisMargin: widget.props.scrollbarProps.crossAxisMargin,
                            mainAxisMargin: widget.props.scrollbarProps.mainAxisMargin,
                            minOverscrollLength: widget.props.scrollbarProps.minOverscrollLength,
                            minThumbLength: widget.props.scrollbarProps.minThumbLength,
                            pressDuration: widget.props.scrollbarProps.pressDuration,
                            shape: widget.props.scrollbarProps.shape,
                            timeToFade: widget.props.scrollbarProps.timeToFade,
                            trackBorderColor: widget.props.scrollbarProps.trackBorderColor,
                            trackColor: widget.props.scrollbarProps.trackColor,
                            trackRadius: widget.props.scrollbarProps.trackRadius,
                            padding: widget.props.scrollbarProps.padding,
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                              child: ListView.builder(
                                hitTestBehavior: widget.props.listViewProps.hitTestBehavior,
                                controller: widget.props.listViewProps.controller ?? scrollController,
                                shrinkWrap: widget.props.listViewProps.shrinkWrap,
                                padding: widget.props.listViewProps.padding,
                                scrollDirection: widget.props.listViewProps.scrollDirection,
                                reverse: widget.props.listViewProps.reverse,
                                primary: widget.props.listViewProps.primary,
                                physics: widget.props.listViewProps.physics,
                                itemExtent: widget.props.listViewProps.itemExtent,
                                addAutomaticKeepAlives: widget.props.listViewProps.addAutomaticKeepAlives,
                                addRepaintBoundaries: widget.props.listViewProps.addRepaintBoundaries,
                                addSemanticIndexes: widget.props.listViewProps.addSemanticIndexes,
                                cacheExtent: widget.props.listViewProps.cacheExtent,
                                semanticChildCount: widget.props.listViewProps.semanticChildCount,
                                dragStartBehavior: widget.props.listViewProps.dragStartBehavior,
                                keyboardDismissBehavior: widget.props.listViewProps.keyboardDismissBehavior,
                                restorationId: widget.props.listViewProps.restorationId,
                                clipBehavior: widget.props.listViewProps.clipBehavior,
                                prototypeItem: widget.props.listViewProps.prototypeItem,
                                itemExtentBuilder: widget.props.listViewProps.itemExtentBuilder,
                                findChildIndexCallback: widget.props.listViewProps.findChildIndexCallback,
                                itemCount: itemCount + (isInfiniteScrollEnded ? 0 : 1),
                                itemBuilder: (context, index) {
                                  if (index < itemCount) {
                                    var item = snapshot.data![index];
                                    return widget.isMultiSelectionMode
                                        ? _itemWidgetMultiSelection(item)
                                        : _itemWidgetSingleSelection(item);
                                  }
                                  //if infiniteScroll enabled && data received not less then take request
                                  else if (!isInfiniteScrollEnded) {
                                    _manageLoadMoreItems(searchBoxController.text, skip: itemCount, showLoading: false);
                                    return _infiniteScrollLoadingMoreWidget(itemCount);
                                  }

                                  return SizedBox.shrink();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      _loadingWidget()
                    ],
                  ),
                ),
                _multiSelectionValidation(),
              ],
            );
          }),
    );
  }

  Widget _infiniteScrollLoadingMoreWidget(int loadedItems) {
    if (widget.props.infiniteScrollProps?.loadingMoreBuilder != null) {
      return widget.props.infiniteScrollProps!.loadingMoreBuilder!(context, loadedItems);
    }
    return const Center(child: CircularProgressIndicator());
  }

  ///validation of selected items
  void onValidate() {
    closePopup();
    if (widget.onChanged != null) widget.onChanged!(_selectedItems);
  }

  Widget _multiSelectionValidation() {
    if (!widget.isMultiSelectionMode) return SizedBox.shrink();

    Widget defaultValidation = Padding(
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: onValidate,
          child: Text("OK"),
        ),
      ),
    );

    if (widget.props.validationBuilder != null) {
      return widget.props.validationBuilder!(context, _selectedItems);
    }

    return defaultValidation;
  }

  Widget _noDataWidget() {
    if (widget.props.emptyBuilder != null) {
      return widget.props.emptyBuilder!(context, searchBoxController.text);
    }

    return Container(
      height: 70,
      alignment: Alignment.center,
      child: Text("No data found"),
    );
  }

  Widget _errorWidget(dynamic error) {
    if (widget.props.errorBuilder != null) {
      return widget.props.errorBuilder!(
        context,
        searchBoxController.text,
        error,
      );
    }

    return Container(
      alignment: Alignment.center,
      child: Text(
        error?.toString() ?? 'Unknown Error',
      ),
    );
  }

  Widget _loadingWidget() {
    return ValueListenableBuilder(
        valueListenable: _loadingNotifier,
        builder: (context, bool isLoading, wid) {
          if (isLoading) {
            if (widget.props.loadingBuilder != null) {
              return widget.props.loadingBuilder!(
                context,
                searchBoxController.text,
              );
            }

            return Container(
              height: 70,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          return const SizedBox.shrink();
        });
  }

  List<T> _applyFilter(String filter) {
    return _cachedItems.where((i) {
      if (widget.filterFn != null) {
        return (widget.filterFn!(i, filter));
      } else if (i.toString().toLowerCase().contains(filter.toLowerCase())) {
        return true;
      } else if (widget.itemAsString != null) {
        return (widget.itemAsString!(i)).toLowerCase().contains(filter.toLowerCase());
      }
      return false;
    }).toList();
  }

  Future<void> _manageLoadItems(
    String filter, {
    bool isFirstLoad = false,
  }) async {
    //if the filter is not handled by user, we load full list once
    if (!widget.props.cacheItems) _cachedItems.clear();

    //case filtering locally (no need to load new data)
    if (!isFirstLoad && !widget.props.disableFilter && widget.props.cacheItems && isInfiniteScrollEnded) {
      _addDataToStream(_applyFilter(filter));
      return;
    }

    return _manageLoadMoreItems(filter);
  }

  Future<void> _manageLoadMoreItems(
    String filter, {
    int? skip,
    bool showLoading = true,
  }) async {
    if (widget.items == null) return;

    final loadProps = widget.props.infiniteScrollProps?.loadProps;

    if (showLoading) {
      _loadingNotifier.value = true;
    }

    try {
      final List<T> myItems = await widget.items!(filter, loadProps?.copy(skip: skip));

      if (loadProps != null) {
        isInfiniteScrollEnded = myItems.length < loadProps.take;
      }

      //add new online items to cache list
      _cachedItems.addAll(myItems);

      //manage data filtering
      if (widget.props.disableFilter) {
        _addDataToStream(_cachedItems);
      } else {
        _addDataToStream(_applyFilter(filter));
      }
    } catch (e) {
      _setErrorToStream(e);
    }

    if (showLoading) {
      _loadingNotifier.value = false;
    }
  }

  void _addDataToStream(List<T> data) {
    if (_itemsStream.isClosed) return;
    _itemsStream.add(data);

    //update showed data list
    _currentShowedItems.clear();
    _currentShowedItems.addAll(data);

    if (widget.props.onItemsLoaded != null) {
      widget.props.onItemsLoaded!(data);
    }
  }

  void _setErrorToStream(Object error, [StackTrace? stackTrace]) {
    if (_itemsStream.isClosed) return;
    _itemsStream.addError(error, stackTrace);
  }

  Widget _itemWidgetSingleSelection(T item) {
    if (widget.props.itemBuilder != null) {
      var w = widget.props.itemBuilder!(
        context,
        item,
        _isDisabled(item),
        !widget.props.showSelectedItems ? false : _isSelectedItem(item),
      );

      if (widget.props.interceptCallBacks) return w;

      return CustomInkWell(
        clickProps: widget.props.itemClickProps,
        onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
        child: IgnorePointer(child: w),
      );
    } else {
      return ListTile(
        enabled: !_isDisabled(item),
        title: Text(_itemAsString(item)),
        selected: !widget.props.showSelectedItems ? false : _isSelectedItem(item),
        onTap: _isDisabled(item) ? null : () => _handleSelectedItem(item),
      );
    }
  }

  Widget _itemWidgetMultiSelection(T item) {
    if (widget.props.checkBoxBuilder != null) {
      return CheckBoxWidget(
        clickProps: widget.props.itemClickProps,
        checkBox: (cxt, checked) {
          return widget.props.checkBoxBuilder!(cxt, item, _isDisabled(item), checked);
        },
        interceptCallBacks: widget.props.interceptCallBacks,
        textDirection: widget.props.textDirection,
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: _isDisabled(item),
        onChanged: (c) => _handleSelectedItem(item),
      );
    } else {
      return CheckBoxWidget(
        clickProps: widget.props.itemClickProps,
        textDirection: widget.props.textDirection,
        interceptCallBacks: widget.props.interceptCallBacks,
        layout: (context, isChecked) => _itemWidgetSingleSelection(item),
        isChecked: _isSelectedItem(item),
        isDisabled: _isDisabled(item),
        onChanged: (c) => _handleSelectedItem(item),
      );
    }
  }

  bool _isDisabled(T item) => widget.props.disabledItemFn != null && (widget.props.disabledItemFn!(item)) == true;

  /// selected item will be highlighted only when [widget.showSelectedItems] is true,
  /// if our object is String [widget.compareFn] is not required , other wises it's required
  bool _isSelectedItem(T item) => _itemIndexInList(_selectedItems, item) > -1;

  ///test if list has an item T
  ///if contains return index of item in the list, -1 otherwise
  int _itemIndexInList(List<T> list, T item) => list.indexWhere((i) => _isEqual(i, item));

  ///compared two items base on user params
  bool _isEqual(T i1, T i2) {
    if (widget.compareFn != null) {
      return widget.compareFn!(i1, i2);
    } else {
      return i1 == i2;
    }
  }

  Widget _searchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.props.title ?? const SizedBox.shrink(),
        if (widget.props.showSearchBox)
          Padding(
            padding: widget.props.searchFieldProps.padding,
            child: Semantics(
              textField: true,
              child: TextField(
                onChanged: widget.props.searchFieldProps.onChanged,
                onEditingComplete: widget.props.searchFieldProps.onEditingComplete,
                onSubmitted: widget.props.searchFieldProps.onSubmitted,
                onTapAlwaysCalled: widget.props.searchFieldProps.onTapAlwaysCalled,
                enableIMEPersonalizedLearning: widget.props.searchFieldProps.enableIMEPersonalizedLearning,
                clipBehavior: widget.props.searchFieldProps.clipBehavior,
                style: widget.props.searchFieldProps.style,
                controller: searchBoxController,
                focusNode: widget.props.searchFieldProps.focusNode,
                autofocus: widget.props.searchFieldProps.autofocus,
                decoration: widget.props.searchFieldProps.decoration,
                keyboardType: widget.props.searchFieldProps.keyboardType,
                textInputAction: widget.props.searchFieldProps.textInputAction,
                textCapitalization: widget.props.searchFieldProps.textCapitalization,
                strutStyle: widget.props.searchFieldProps.strutStyle,
                textAlign: widget.props.searchFieldProps.textAlign,
                textAlignVertical: widget.props.searchFieldProps.textAlignVertical,
                textDirection: widget.props.searchFieldProps.textDirection,
                readOnly: widget.props.searchFieldProps.readOnly,
                contextMenuBuilder: widget.props.searchFieldProps.contextMenuBuilder,
                showCursor: widget.props.searchFieldProps.showCursor,
                obscuringCharacter: widget.props.searchFieldProps.obscuringCharacter,
                obscureText: widget.props.searchFieldProps.obscureText,
                autocorrect: widget.props.searchFieldProps.autocorrect,
                smartDashesType: widget.props.searchFieldProps.smartDashesType,
                smartQuotesType: widget.props.searchFieldProps.smartQuotesType,
                enableSuggestions: widget.props.searchFieldProps.enableSuggestions,
                maxLines: widget.props.searchFieldProps.maxLines,
                minLines: widget.props.searchFieldProps.minLines,
                expands: widget.props.searchFieldProps.expands,
                maxLengthEnforcement: widget.props.searchFieldProps.maxLengthEnforcement,
                maxLength: widget.props.searchFieldProps.maxLength,
                onAppPrivateCommand: widget.props.searchFieldProps.onAppPrivateCommand,
                inputFormatters: widget.props.searchFieldProps.inputFormatters,
                enabled: widget.props.searchFieldProps.enabled,
                cursorWidth: widget.props.searchFieldProps.cursorWidth,
                cursorHeight: widget.props.searchFieldProps.cursorHeight,
                cursorRadius: widget.props.searchFieldProps.cursorRadius,
                cursorColor: widget.props.searchFieldProps.cursorColor,
                selectionHeightStyle: widget.props.searchFieldProps.selectionHeightStyle,
                selectionWidthStyle: widget.props.searchFieldProps.selectionWidthStyle,
                keyboardAppearance: widget.props.searchFieldProps.keyboardAppearance,
                scrollPadding: widget.props.searchFieldProps.scrollPadding,
                dragStartBehavior: widget.props.searchFieldProps.dragStartBehavior,
                enableInteractiveSelection: widget.props.searchFieldProps.enableInteractiveSelection,
                selectionControls: widget.props.searchFieldProps.selectionControls,
                onTap: widget.props.searchFieldProps.onTap,
                mouseCursor: widget.props.searchFieldProps.mouseCursor,
                buildCounter: widget.props.searchFieldProps.buildCounter,
                scrollController: widget.props.searchFieldProps.scrollController,
                scrollPhysics: widget.props.searchFieldProps.scrollPhysics,
                autofillHints: widget.props.searchFieldProps.autofillHints,
                restorationId: widget.props.searchFieldProps.restorationId,
                canRequestFocus: widget.props.searchFieldProps.canRequestFocus,
                statesController: widget.props.searchFieldProps.statesController,
                contentInsertionConfiguration: widget.props.searchFieldProps.contentInsertionConfiguration,
                cursorErrorColor: widget.props.searchFieldProps.cursorErrorColor,
                cursorOpacityAnimates: widget.props.searchFieldProps.cursorOpacityAnimates,
                ignorePointers: widget.props.searchFieldProps.ignorePointers,
                magnifierConfiguration: widget.props.searchFieldProps.magnifierConfiguration,
                onTapOutside: widget.props.searchFieldProps.onTapOutside,
                scribbleEnabled: widget.props.searchFieldProps.scribbleEnabled,
                undoController: widget.props.searchFieldProps.undoController,
                spellCheckConfiguration: widget.props.searchFieldProps.spellCheckConfiguration,
              ),
            ),
          )
      ],
    );
  }

  Widget _suggestedItemsWidget() {
    if (!widget.props.suggestionsProps.showSuggestions) {
      return SizedBox.shrink();
    }

    return StreamBuilder<List<T>>(
      stream: _itemsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SuggestionsWidget<T>(
            dropdownItems: snapshot.data!,
            props: widget.props.suggestionsProps,
            isSelectedItemFn: (item) => _isSelectedItem(item),
            isDisabledItemFn: (item) => _isDisabled(item),
            itemAsString: (item) => _itemAsString(item),
            onClick: (value) => _handleSelectedItem(value),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  void _handleSelectedItem(T newSelectedItem) {
    if (widget.isMultiSelectionMode) {
      if (_isSelectedItem(newSelectedItem)) {
        _selectedItemsNotifier.value = List.from(_selectedItems)..removeWhere((i) => _isEqual(newSelectedItem, i));
        if (widget.props.onItemRemoved != null) {
          widget.props.onItemRemoved!(_selectedItems, newSelectedItem);
        }
      } else {
        _selectedItemsNotifier.value = List.from(_selectedItems)..add(newSelectedItem);
        if (widget.props.onItemAdded != null) {
          widget.props.onItemAdded!(_selectedItems, newSelectedItem);
        }
      }
    } else {
      closePopup();
      if (widget.onChanged != null) {
        widget.onChanged!(List.filled(1, newSelectedItem));
      }
    }
  }

  ///function that return the String value of an object
  String _itemAsString(T data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString!(data);
    } else {
      return data.toString();
    }
  }

  void selectItems(List<T> itemsToSelect) {
    for (var i in itemsToSelect) {
      if (!_isSelectedItem(i) /*check if the item is already selected*/ && !_isDisabled(i) /*escape disabled items*/) {
        _selectedItems.add(i);
        if (widget.props.onItemAdded != null) {
          widget.props.onItemAdded!(_selectedItems, i);
        }
      }
    }
    _selectedItemsNotifier.value = List.from(_selectedItems);
  }

  void deselectItems(List<T> itemsToDeselect) {
    List<T> tempList = List.from(itemsToDeselect);
    for (var i in tempList) {
      var index = _itemIndexInList(_selectedItems, i);
      if (index > -1) /*check if the item is already selected*/ {
        _selectedItems.removeAt(index);
        if (widget.props.onItemRemoved != null) {
          widget.props.onItemRemoved!(_selectedItems, i);
        }
      }
    }
    _selectedItemsNotifier.value = List.from(_selectedItems);
  }

  ///close popup
  void closePopup() => Navigator.pop(context);

  void selectAllItems() => selectItems(_currentShowedItems);

  void deselectAllItems() => deselectItems(_selectedItems);

  bool get isAllItemSelected => _listEquals(_selectedItems, _currentShowedItems);

  List<T> get getSelectedItem => List.from(_selectedItems);

  List<T> get getLoadedItems => List.from(_currentShowedItems);

  bool _listEquals(List<T>? a, List<T>? b) {
    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    if (identical(a, b)) {
      return true;
    }
    for (int index = 0; index < b.length; index += 1) {
      if (_itemIndexInList(a, b[index]) == -1) {
        return false;
      }
    }
    return true;
  }
}
