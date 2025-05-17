import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CropSchemesDropdownPage extends StatefulWidget {
  @override
  _CropSchemesDropdownPageState createState() => _CropSchemesDropdownPageState();
}

class _CropSchemesDropdownPageState extends State<CropSchemesDropdownPage> {
  String? _selectedCrop;
  List<Map<String, String>> _schemes = [];

  // Dropdown Options
  final List<String> crops = [
    'Wheat',
    'Rice',
    'Sugarcane',
    'Cotton',
    'Maize',
    'Pulses',
    'Barley',
    'Sorghum',
    'Millet',
    'Potato'
  ];

  // Crop -> Schemes map
  final Map<String, List<Map<String, String>>> cropToSchemes = {
    'Wheat': [
      {'Pradhan Mantri Fasal Bima Yojana (PMFBY)': 'https://pmfby.gov.in/ '},
      {'National Food Security Mission (NFSM)': 'https://nfsmin.nic.in/ '},
      {'Minimum Support Price (MSP)': 'https://agriapps.dac.gov.in/MSP2023/MSPHomePage.aspx '},
      {'Sub-Mission on Agricultural Mechanization (SMAM)': 'https://www.icar.org.in/content/sub-mission-agricultural-mechanization-smam '},
      
    ],
    'Rice': [
      {'National Mission for Sustainable Agriculture (NMSA)': 'https://nmsa.dacnet.nic.in/ '},
      {'Paramparagat Krishi Vikas Yojana (PKVY)': 'https://pkvy.gov.in/ '},
      {'MSP for Paddy': 'https://agriapps.dac.gov.in/MSP2023/MSPHomePage.aspx '},
      {'Accelerated Irrigation Benefit Programme': 'https://ambm.gov.in/ '}
    ],
    'Sugarcane': [
      {'National Sugar Policy': 'https://dci.gov.in/ '},
      {'Ethanol Blending Programme': 'https://ethanolpetro.com/ '},
      {'Financial Assistance for setting up Agro-Based Units': 'https://msme.gov.in/ '},
      {'Pradhan Mantri Fasal Bima Yojana (PMFBY)': 'https://pmfby.gov.in/ '}
    ],
    'Cotton': [
      {'Technology Mission on Cotton': 'https://tmc.nic.in/ '},
      {'Paramparagat Krishi Vikas Yojana (PKVY)': 'https://pkvy.gov.in/ '},
      {'National Horticulture Mission': 'https://nhm.gov.in/ '}
    ],
    'Maize': [
      {'Mission for Integrated Development of Horticulture (MIDH)': 'https://midh.gov.in/ '},
      {'National Agriculture Development Programme (NADP)': 'https://rkvy.gov.in/ '},
      {'NFSM – Coarse Cereals including Maize': 'https://nfsmin.nic.in/ '}
    ],
    'Pulses': [
      {'Pradhan Mantri Annadata Aay Sanrakshan Abhiyan (PM-AASHA)': 'https://pmaasha.gov.in/ '},
      {'NFSM – Pulses': 'https://nfsmin.nic.in/ '},
      {'Price Deficiency Payment Scheme': 'https://pmksy.gov.in/ '}
    ],
    'Barley': [
      {'National Food Security Mission (NFSM)': 'https://nfsmin.nic.in/ '},
      {'National Agriculture Development Programme': 'https://rkvy.gov.in/ '}
    ],
    'Sorghum': [
      {'National Millet Mission': 'https://nms.nic.in/ '},
      {'National Food Security Mission (NFSM)': 'https://nfsmin.nic.in/ '}
    ],
    'Millet': [
      {'National Millet Mission': 'https://nms.nic.in/ '},
      {'Pradhan Mantri Fasal Bima Yojana (PMFBY)': 'https://pmfby.gov.in/ '}
    ],
    'Potato': [
      {'National Horticulture Mission': 'https://nhm.gov.in/ '},
      {'Sub-Mission on Agricultural Mechanization (SMAM)': 'https://www.icar.org.in/content/sub-mission-agricultural-mechanization-smam '}
    ]
  };

  void _onCropSelected(String? crop) {
    if (crop == null) return;

    setState(() {
      _selectedCrop = crop;
      _schemes = cropToSchemes[crop] ?? [];
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Government Crop Schemes"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select a crop:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Choose a crop'),
              value: _selectedCrop,
              onChanged: _onCropSelected,
              items: crops.map((String crop) {
                return DropdownMenuItem<String>(
                  value: crop,
                  child: Text(crop),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            (_schemes.isNotEmpty)
                ? Expanded(
                    child: ListView.separated(
                      itemCount: _schemes.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        final entry = _schemes[index];
                        final name = entry.keys.first;
                        final url = entry.values.first;

                        return ListTile(
                          title: Text(name),
                          trailing: Icon(Icons.open_in_new),
                          onTap: () => _launchUrl(url),
                        );
                      },
                    ),
                  )
                : (_selectedCrop != null)
                    ? Center(
                        child: Text('No schemes found for $_selectedCrop.'),
                      )
                    : Center(
                        child: Text('Please select a crop to view schemes.'),
                      ),
          ],
        ),
      ),
    );
  }
}