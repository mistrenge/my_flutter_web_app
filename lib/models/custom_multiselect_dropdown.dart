import 'package:flutter/material.dart';
import 'package:my_flutter_app/styles/styles.dart';

class CustomMultiselectDropDown extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;
  final List<String> options;
  final List<String> selectedValues;
  final String labelText;
  final String filterName; // Neue Eigenschaft für den Filternamen

  const CustomMultiselectDropDown({super.key, 
    required this.onSelectionChanged,
    required this.options,
    required this.selectedValues,
    required this.labelText,
    required this.filterName, // Filtername beim Erstellen übergeben
  });

  @override
  _CustomMultiselectDropDownState createState() => _CustomMultiselectDropDownState();
}

class _CustomMultiselectDropDownState extends State<CustomMultiselectDropDown> {
  late List<String> _selectedItems;
  late List<String> _filteredOptions;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredOptions = List.from(widget.options);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _selectedItems = widget.selectedValues.isEmpty ? List.from(widget.options) : List.from(widget.selectedValues);
    });
  }

  void _filterOptions(String query) {
    setState(() {
      _searchQuery = query;
      _filteredOptions = widget.options
          .where((option) => option.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectAll(bool select) {
    setState(() {
      _selectedItems = select ? List.from(widget.options) : [];
      widget.onSelectionChanged(_selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayOptions = _searchQuery.isEmpty ? widget.options : _filteredOptions;

    return Container(
      margin: const EdgeInsets.only(top: 2.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ExpansionTile(
        iconColor: Colors.black,
        title: Text(
          _selectedItems.isEmpty
              ? '${widget.filterName}: ${widget.labelText}'  // Zeige den Filternamen zusammen mit der leeren Auswahl
              : _selectedItems.length == widget.options.length
                  ? widget.filterName  // Zeige den Filternamen, wenn alle Optionen ausgewählt sind
                  : '${widget.filterName}: ${_selectedItems.join(', ')}',  // Zeige den Filternamen und die ausgewählten Optionen
          style: Theme.of(context).textTheme.titleLarge,
          overflow: TextOverflow.ellipsis,
        ),
        children: <Widget>[
          // Suchfeld
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Suche',
                border: Theme.of(context).inputDecorationTheme.border,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
              ),
              onChanged: _filterOptions,
            ),
          ),
          // Alles auswählen/abwählen
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectAll(true),
                    style: Theme.of(context).textButtonTheme.style,
                    child: const Text('Alles auswählen'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectAll(false),
                    style: Theme.of(context).textButtonTheme.style,
                    child: const Text('Alles abwählen'),
                  ),
                ),
              ],
            ),
          ),
          // Liste der Optionen
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView(
              shrinkWrap: true,
              children: displayOptions.map((option) {
                final isSelected = _selectedItems.contains(option);

                return _ViewItem(
                  item: option,
                  itemSelected: isSelected,
                  onItemSelected: (selected) {
                    setState(() {
                      if (selected) {
                        if (!_selectedItems.contains(option)) {
                          _selectedItems.add(option);
                        }
                      } else {
                        _selectedItems.remove(option);
                      }
                      widget.onSelectionChanged(_selectedItems);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
  final String item;
  final bool itemSelected;
  final Function(bool) onItemSelected;

  const _ViewItem({
    required this.item,
    required this.itemSelected,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          SizedBox(
            height: 24.0,
            width: 24.0,
            child: Checkbox(
              value: itemSelected,
              onChanged: (bool? value) {
                onItemSelected(value ?? false);
              },
              activeColor: filterColor, // Verwende die definierte Filterfarbe
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
