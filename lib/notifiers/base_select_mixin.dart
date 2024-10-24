import 'package:flutter/material.dart';


/*
We use a mixin to harmonize the system and because we need to be able to open a challenge 
from a list of challenges and from a group.
It's combined with the provider found in the main file, which acts as a listener.
*/

mixin BaseSelectMixin on ChangeNotifier {

  int _selectedItem = 0;
  int _previousItem = 0;

  int get selectedItemId => _selectedItem;
  int get previousItem => _previousItem;
  
  set selectedItemId(int value) {
      if (_selectedItem != value) {
        _previousItem = _selectedItem;
        _selectedItem = value;
        notifyListeners();
      }
    }

  set previousItem(int value) {
    if (_selectedItem != value) {
      _previousItem = _selectedItem;
    }
  }
}
