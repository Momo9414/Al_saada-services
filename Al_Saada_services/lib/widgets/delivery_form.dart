import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/directions.dart' as directions;
import 'package:flutter_google_places/flutter_google_places.dart';

class DeliveryForm extends StatefulWidget {
  const DeliveryForm({super.key});

  @override
  State<DeliveryForm> createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(48.8566, 2.3522);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  String? _startAddress;
  String? _destinationAddress;
  LatLng? _startLocation;
  LatLng? _destinationLocation;
  String? _placeDistance;
  
  // Définition des constantes pour l'API key
  static const String _apiKey = 'VOTRE_CLE_API';
  final places = GoogleMapsPlaces(apiKey: _apiKey);
  final directionsApi = directions.GoogleMapsDirections(apiKey: _apiKey);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
    mapController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nouvelle livraison',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startController,
                decoration: InputDecoration(
                  labelText: 'Adresse de départ',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onTap: () async {
                  await _searchPlace(true);
                },
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: 'Adresse de destination',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onTap: () async {
                  await _searchPlace(false);
                },
                readOnly: true,
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 11.0,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
              ),
              if (_placeDistance != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Distance: $_placeDistance',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startLocation != null && _destinationLocation != null
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            // Traiter la soumission du formulaire
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Confirmer la livraison'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchPlace(bool isStartLocation) async {
    final Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: 'VOTRE_CLE_API',
      mode: Mode.overlay,
      language: "fr",
      components: [Component(Component.country, "fr")],
    );

    if (p != null) {
      final PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      setState(() {
        if (isStartLocation) {
          _startLocation = LatLng(lat, lng);
          _startAddress = detail.result.formattedAddress;
          _startController.text = detail.result.formattedAddress ?? '';
          _addMarker(_startLocation!, "Départ", BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
        } else {
          _destinationLocation = LatLng(lat, lng);
          _destinationAddress = detail.result.formattedAddress;
          _destinationController.text = detail.result.formattedAddress ?? '';
          _addMarker(_destinationLocation!, "Arrivée", BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
        }
      });

      if (_startLocation != null && _destinationLocation != null) {
        await _getDirections();
      }
    }
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(id),
          position: position,
          icon: descriptor,
          infoWindow: InfoWindow(title: id),
        ),
      );
    });
  }

  Future<void> _getDirections() async {
    final response = await directionsApi.directionsWithLocation(
      directions.Location(lat: _startLocation!.latitude, lng: _startLocation!.longitude),
      directions.Location(lat: _destinationLocation!.latitude, lng: _destinationLocation!.longitude),
      travelMode: directions.TravelMode.driving,
    );

    if (response.status == 'OK') {
      setState(() {
        _placeDistance = response.routes[0].legs[0].distance!.text;
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: _decodePolyline(response.routes[0].overviewPolyline!.points),
            color: Colors.blue,
            width: 5,
          ),
        );
      });

      final bounds = LatLngBounds(
        southwest: LatLng(
          response.routes[0].bounds!.southwest.lat,
          response.routes[0].bounds!.southwest.lng,
        ),
        northeast: LatLng(
          response.routes[0].bounds!.northeast.lat,
          response.routes[0].bounds!.northeast.lng,
        ),
      );
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }
}