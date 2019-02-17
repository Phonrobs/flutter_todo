import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;

import '../models/locationData.dart';

class LocationPickerWidget extends StatefulWidget {
  final LocationData locationData;
  final Function(LocationData) setLocationData;

  LocationPickerWidget(this.locationData, this.setLocationData);

  @override
  State<StatefulWidget> createState() {
    return _LocationPickerWidgetState();
  }
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  final FocusNode _addressFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  LocationData _locationData;
  Uri _staticMapUri;

  @override
  void initState() {
    _addressFocusNode.addListener(_updateLocation);

    if (widget.locationData != null) {
      getStaticMap(widget.locationData.address);
    } else {
      getStaticMap(null);
    }

    super.initState();
  }

  @override
  void dispose() {
    _addressFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    if (address == null || address.isEmpty) {
      widget.setLocationData(null);

      setState(() {
        _staticMapUri = null;
      });

      return;
    }

    final Uri geoCodeUri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'address': address,
        'key': 'AIzaSyBuuuLEBC16MjNQSclJLBZxBlrDc0_jkno',
      },
    );

    final http.Response response = await http.get(geoCodeUri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    final coords = decodedResponse['results'][0]['geometry']['location'];

    _locationData =
        LocationData(formattedAddress, coords['lat'], coords['lng']);

    final StaticMapProvider staticMapProvidr =
        StaticMapProvider('AIzaSyBuuuLEBC16MjNQSclJLBZxBlrDc0_jkno');

    final Uri mapUri = staticMapProvidr.getStaticUriWithMarkers(
        [Marker('position', 'Position', _locationData.lat, _locationData.lng)],
        center: Location(_locationData.lat, _locationData.lng),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);

    widget.setLocationData(_locationData);

    setState(() {
      _addressInputController.text = _locationData.address;
      _staticMapUri = mapUri;
    });
  }

  void _updateLocation() {
    if (!_addressFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  void _showFullMap() {
    final List<Marker> markers = [
      Marker('position', 'Position', _locationData.lat, _locationData.lng)
    ];

    final CameraPosition cameraPosition =
        CameraPosition(Location(_locationData.lat, _locationData.lng), 14.0);

    final MapView mapView = MapView();

    mapView.show(
      MapOptions(
        initialCameraPosition: cameraPosition,
        mapViewType: MapViewType.normal,
        title: 'Location',
      ),
      toolbarActions: [ToolbarAction('Close', 1)],
    );

    mapView.onToolbarAction.listen((int id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });

    mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressFocusNode,
          decoration: InputDecoration(labelText: 'Where to do'),
          controller: _addressInputController,
        ),
        SizedBox(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            _showFullMap();
          },
          child: Image.network(_staticMapUri.toString()),
        ),
      ],
    );
  }
}
