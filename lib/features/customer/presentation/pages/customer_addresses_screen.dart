import 'package:final_project/features/firebase/data/services/customer_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class CustomerAddressesScreen extends StatefulWidget {
  const CustomerAddressesScreen({super.key});

  @override
  State<CustomerAddressesScreen> createState() =>
      _CustomerAddressesScreenState();
}

class _CustomerAddressesScreenState
    extends State<CustomerAddressesScreen> {
      final Geocoding _geocoding = Geocoding();
  List<Map<String, dynamic>> addresses = [];

  bool isLoading = true;
  bool isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  // ==========================================================
  // LOAD SAVED ADDRESSES
  // ==========================================================

  Future<void> _loadAddresses() async {
    try {
      final result =
          await CustomerProfileService.getAddresses();

      if (!mounted) return;

      setState(() {
        addresses = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to load addresses: $e',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // ADD LOCATION
  // ==========================================================

  Future<void> _addCurrentLocation() async {
    if (isGettingLocation) return;

    setState(() {
      isGettingLocation = true;
    });

    try {
      // --------------------------------------------------------
      // CHECK LOCATION SERVICE
      // --------------------------------------------------------

      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Location is turned off',
              ),
              content: const Text(
                'Please turn on your phone location service '
                'and try again.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        return;
      }

      // --------------------------------------------------------
      // CHECK PERMISSION
      // --------------------------------------------------------

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permission was denied.',
        );
      }

      if (permission ==
          LocationPermission.deniedForever) {
        if (!mounted) return;

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Location Permission Required',
              ),
              content: const Text(
                'Location permission has been permanently '
                'denied. Please enable it from app settings.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF12A66A),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);

                    await Geolocator.openAppSettings();
                  },
                  child: const Text('Settings'),
                ),
              ],
            );
          },
        );

        return;
      }

      // --------------------------------------------------------
      // GET CURRENT LOCATION
      // --------------------------------------------------------

      final position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // --------------------------------------------------------
      // CONVERT COORDINATES INTO ADDRESS
      // --------------------------------------------------------
      final List<Placemark> placemarks =
      await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) {
        throw Exception(
          'Could not find an address for your location.',
        );
      }
      final Placemark place = placemarks.first;
      final String address =[
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((value) => value != null && value!.trim().isNotEmpty).join(',');
      // --------------------------------------------------------
      // SAVE TO FIRESTORE
      // --------------------------------------------------------
      await CustomerProfileService.addAddress(
        address: address,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // --------------------------------------------------------
      // RELOAD ADDRESSES
      // --------------------------------------------------------

      await _loadAddresses();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location added successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to get your location: $e',
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isGettingLocation = false;
      });
    }
  }

  // ==========================================================
  // FORMAT ADDRESS
  // ==========================================================

  String _formatAddress(Placemark place) {
    final parts = <String>[];

    if (place.street != null &&
        place.street!.trim().isNotEmpty) {
      parts.add(place.street!.trim());
    }

    if (place.subLocality != null &&
        place.subLocality!.trim().isNotEmpty &&
        !parts.contains(place.subLocality!.trim())) {
      parts.add(place.subLocality!.trim());
    }

    if (place.locality != null &&
        place.locality!.trim().isNotEmpty &&
        !parts.contains(place.locality!.trim())) {
      parts.add(place.locality!.trim());
    }

    if (place.administrativeArea != null &&
        place.administrativeArea!.trim().isNotEmpty &&
        !parts.contains(
          place.administrativeArea!.trim(),
        )) {
      parts.add(place.administrativeArea!.trim());
    }

    if (place.country != null &&
        place.country!.trim().isNotEmpty &&
        !parts.contains(place.country!.trim())) {
      parts.add(place.country!.trim());
    }

    if (parts.isEmpty) {
      return 'Current Location';
    }

    return parts.join(', ');
  }

  // ==========================================================
  // DELETE ADDRESS
  // ==========================================================

  Future<void> _deleteAddress(
    Map<String, dynamic> address,
  ) async {
    try {
      await CustomerProfileService.deleteAddress(
        address,
      );

      await _loadAddresses();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Address removed',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to remove address: $e',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // DELETE CONFIRMATION
  // ==========================================================

  Future<void> _confirmDelete(
    Map<String, dynamic> address,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Remove Address',
          ),
          content: const Text(
            'Are you sure you want to remove this address?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _deleteAddress(address);
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF172033),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'My Addresses',
          style: TextStyle(
            fontSize: size.width * 0.055,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF172033),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.015,
              ),

              Text(
                'Manage your saved locations',
                style: TextStyle(
                  fontSize: size.width * 0.038,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(
                height: size.height * 0.025,
              ),

              // ==================================================
              // ADD LOCATION BUTTON
              // ==================================================

              GestureDetector(
                onTap: isGettingLocation
                    ? null
                    : _addCurrentLocation,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.019,
                    horizontal: size.width * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7F1),
                    borderRadius:
                        BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF12A66A),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.11,
                        height: size.width * 0.11,
                        decoration:
                            const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: isGettingLocation
                            ? const Padding(
                                padding:
                                    EdgeInsets.all(10),
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color:
                                      Color(0xFF12A66A),
                                ),
                              )
                            : Icon(
                                Icons.my_location_rounded,
                                size:
                                    size.width * 0.055,
                                color:
                                    const Color(
                                  0xFF12A66A,
                                ),
                              ),
                      ),

                      SizedBox(
                        width: size.width * 0.035,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              isGettingLocation
                                  ? 'Getting your location...'
                                  : 'Add Current Location',
                              style: TextStyle(
                                fontSize:
                                    size.width * 0.038,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    const Color(
                                  0xFF172033,
                                ),
                              ),
                            ),

                            SizedBox(
                              height:
                                  size.height * 0.004,
                            ),

                            Text(
                              'Automatically detect your current address',
                              style: TextStyle(
                                fontSize:
                                    size.width * 0.030,
                                color:
                                    Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: size.width * 0.035,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: size.height * 0.03,
              ),

              // ==================================================
              // SAVED ADDRESSES TITLE
              // ==================================================

              Text(
                'Saved Addresses',
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF172033),
                ),
              ),

              SizedBox(
                height: size.height * 0.015,
              ),

              // ==================================================
              // ADDRESS LIST
              // ==================================================

              Expanded(
                child: isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(
                          color: Color(0xFF12A66A),
                        ),
                      )
                    : addresses.isEmpty
                        ? _buildEmptyState(
                            size,
                          )
                        : ListView.builder(
                            padding:
                                EdgeInsets.only(
                              bottom:
                                  size.height * 0.03,
                            ),
                            itemCount:
                                addresses.length,
                            itemBuilder:
                                (context, index) {
                              return _buildAddressCard(
                                size,
                                addresses[index],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState(
    Size size,
  ) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.045,
          horizontal: size.width * 0.06,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE5EAF0),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.07),
              blurRadius: 12,
              spreadRadius: 1,
              offset:
                  const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size.width * 0.18,
              height: size.width * 0.18,
              decoration:
                  const BoxDecoration(
                color: Color(0xFFEAF7F1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: size.width * 0.09,
                color: const Color(0xFF12A66A),
              ),
            ),

            SizedBox(
              height: size.height * 0.018,
            ),

            Text(
              'No addresses yet',
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF172033),
              ),
            ),

            SizedBox(
              height: size.height * 0.008,
            ),

            Text(
              'Add your current location to use it for service requests.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.034,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ADDRESS CARD
  // ==========================================================

  Widget _buildAddressCard(
    Size size,
    Map<String, dynamic> address,
  ) {
    final addressText =
        address['address']?.toString() ??
            'Unknown address';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: size.height * 0.012,
      ),
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.018,
        horizontal: size.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset:
                const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.11,
            height: size.width * 0.11,
            decoration:
                const BoxDecoration(
              color: Color(0xFFEAF7F1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: size.width * 0.055,
              color: const Color(0xFF12A66A),
            ),
          ),

          SizedBox(
            width: size.width * 0.035,
          ),

          Expanded(
            child: Text(
              addressText,
              style: TextStyle(
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF172033),
              ),
            ),
          ),

          IconButton(
            padding: EdgeInsets.zero,
            constraints:
                const BoxConstraints(),
            onPressed: () {
              _confirmDelete(address);
            },
            icon: Icon(
              Icons.delete_outline_rounded,
              size: size.width * 0.055,
              color: Colors.red.shade400,
            ),
          ),
        ],
      ),
    );
  }
}