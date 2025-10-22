import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StateBenefitsScreen extends StatefulWidget {
  const StateBenefitsScreen({Key? key}) : super(key: key);

  @override
  State<StateBenefitsScreen> createState() => _StateBenefitsScreenState();
}

class _StateBenefitsScreenState extends State<StateBenefitsScreen> {
  String selectedState = 'Goa';

  final Map<String, List<Map<String, String>>> stateBenefits = {
    'Goa': [
      {
        'scheme': 'Janani Suraksha Yojana (JSY)',
        'description':
        'Cash assistance to pregnant women for institutional delivery',
        'benefits': '₹1000-2000 cash assistance',
        'howToApply': 'Apply at your nearest ASHA worker or health center',
        'link': 'https://www.goa.gov.in/health-schemes',
        'icon': '🏥',
      },
      {
        'scheme': 'Pradhan Mantri Matru Vandana Yojana (PMMVY)',
        'description':
        'Financial assistance of ₹5000 for pregnant and lactating mothers',
        'benefits': '₹5000 in installments',
        'howToApply': 'Apply through nearest ICDS center or ANM',
        'link':
        'https://www.pmmvy.gov.in',
        'icon': '💰',
      },
      {
        'scheme': 'Mamata Scheme',
        'description':
        'Health and nutrition support for pregnant and nursing mothers',
        'benefits': 'Health checkups, nutrition support, cash transfer',
        'howToApply': 'Register at ASHA center during first trimester',
        'link': 'https://wcd.nic.in/mamata-scheme',
        'icon': '🤰',
      },
    ],
    'Maharashtra': [
      {
        'scheme': 'Janani Suraksha Yojana (JSY)',
        'description': 'Safe motherhood program with cash assistance',
        'benefits': 'Free delivery, ₹600 cash assistance for normal delivery',
        'howToApply': 'Register at nearest government hospital or ASHA',
        'link': 'https://aaplesarkar.maharashtra.gov.in',
        'icon': '🏥',
      },
      {
        'scheme': 'Pradhan Mantri Matru Vandana Yojana (PMMVY)',
        'description':
        'Direct cash transfer to pregnant mothers for health and nutrition',
        'benefits': '₹5000 total (₹1000 + ₹2000 + ₹2000)',
        'howToApply': 'Apply at ICDS center or within 6 months of pregnancy',
        'link':
        'https://www.pmmvy.gov.in',
        'icon': '💰',
      },
      {
        'scheme': 'Mukhyamantri Matru Seva Yojana',
        'description':
        'Free antenatal care and delivery services for poor pregnant women',
        'benefits': 'Free checkups, free delivery, free medicines',
        'howToApply': 'Register at government health center with Aadhar',
        'link': 'https://health.maharashtra.gov.in',
        'icon': '🏥',
      },
      {
        'scheme': 'Surakshit Matritva Yojana',
        'description':
        'Nutritional support and medical assistance during pregnancy',
        'benefits': 'Food supplements, iron tablets, health checkups',
        'howToApply': 'Visit nearest health worker or ASHA center',
        'link': 'https://aaplesarkar.maharashtra.gov.in',
        'icon': '🥗',
      },
    ],
    'Uttar Pradesh': [
      {
        'scheme': 'Janani Suraksha Yojana (JSY)',
        'description': 'Institutional delivery promotion scheme',
        'benefits': '₹400-1000 cash assistance + free delivery',
        'howToApply': 'Register at primary health center',
        'link': 'https://up.gov.in/hi/scheme/jsy',
        'icon': '🏥',
      },
      {
        'scheme': 'Pradhan Mantri Matru Vandana Yojana (PMMVY)',
        'description': 'Direct benefit transfer for pregnant women',
        'benefits': '₹5000 in multiple installments',
        'howToApply': 'Apply at ANGANWADI center within first trimester',
        'link':
        'https://www.pmmvy.gov.in',
        'icon': '💰',
      },
      {
        'scheme': 'Asha Yojana',
        'description':
        'Health and nutrition scheme for pregnant women and newborns',
        'benefits': 'Free checkups, nutrition kits, safe delivery',
        'howToApply': 'Register with ASHA worker during pregnancy',
        'link': 'https://health.up.gov.in',
        'icon': '🤰',
      },
    ],
    'Karnataka': [
      {
        'scheme': 'Janani Suraksha Yojana (JSY)',
        'description': 'Safe motherhood initiative with cash assistance',
        'benefits': '₹600 cash + free delivery services',
        'howToApply': 'Register at district hospital or PHC',
        'link': 'https://www.karnataka.gov.in',
        'icon': '🏥',
      },
      {
        'scheme': 'Pradhan Mantri Matru Vandana Yojana (PMMVY)',
        'description':
        'Financial support for health and nutrition during pregnancy',
        'benefits': '₹5000 total assistance',
        'howToApply': 'Apply at ICDS center or health worker',
        'link':
        'https://www.pmmvy.gov.in',
        'icon': '💰',
      },
      {
        'scheme': 'Indiramma Indlu',
        'description': 'Maternity benefit and livelihood scheme',
        'benefits': 'Financial support for pregnant women from BPL families',
        'howToApply': 'Apply through Gram Panchayat or ICDS',
        'link': 'https://www.karnataka.gov.in/en/web',
        'icon': '🏠',
      },
    ],
    'Tamil Nadu': [
      {
        'scheme': 'Janani Suraksha Yojana (JSY)',
        'description': 'Safe delivery promotion scheme',
        'benefits': '₹500-600 cash assistance for delivery',
        'howToApply': 'Register at nearby government hospital',
        'link': 'https://www.tnhealth.tn.gov.in',
        'icon': '🏥',
      },
      {
        'scheme': 'Pradhan Mantri Matru Vandana Yojana (PMMVY)',
        'description': 'Maternity benefit and nutrition support',
        'benefits': '₹5000 direct transfer',
        'howToApply': 'Apply at ANGANWADI center',
        'link':
        'https://www.pmmvy.gov.in',
        'icon': '💰',
      },
      {
        'scheme': 'Nutritious Meal Scheme',
        'description': 'Free nutrition for pregnant and lactating mothers',
        'benefits': 'Free cooked meals during pregnancy period',
        'howToApply': 'Register at ICDS center',
        'link': 'https://www.wcdtnscheme.tn.gov.in',
        'icon': '🍽️',
      },
    ],
    'Rajasthan': [
      {
        'scheme': 'Janani Suraksha Yojana (JSY)',
        'description': 'Institutional delivery support scheme',
        'benefits': '₹400-600 cash for safe delivery',
        'howToApply': 'Register at government health facility',
        'link': 'https://rajasthan.gov.in',
        'icon': '🏥',
      },
      {
        'scheme': 'Pradhan Mantri Matru Vandana Yojana (PMMVY)',
        'description': 'Direct cash transfer scheme',
        'benefits': '₹5000 in installments',
        'howToApply': 'Apply at ICDS/ANGANWADI center',
        'link':
        'https://www.pmmvy.gov.in',
        'icon': '💰',
      },
      {
        'scheme': 'Indira Gandhi Matritva Sahyog Yojana',
        'description':
        'Financial support for pregnant women in rural areas',
        'benefits': 'Cash transfer + nutritional support',
        'howToApply': 'Apply through ICDS center with documents',
        'link': 'https://wcd.rajasthan.gov.in',
        'icon': '💸',
      },
    ],
    'Delhi': [
      {
        'scheme': 'Janani Suraksha Yojana (JSY)',
        'description': 'Safe motherhood scheme in Delhi',
        'benefits': '₹600 cash + free institutional delivery',
        'howToApply': 'Register at nearest government hospital',
        'link': 'https://delhi.gov.in',
        'icon': '🏥',
      },
      {
        'scheme': 'Pradhan Mantri Matru Vandana Yojana (PMMVY)',
        'description': 'Maternity benefit scheme',
        'benefits': '₹5000 direct benefit transfer',
        'howToApply': 'Apply at ICDS center or health facility',
        'link':
        'https://www.pmmvy.gov.in',
        'icon': '💰',
      },
      {
        'scheme': 'Delhi Health Scheme',
        'description': 'Comprehensive health coverage for mothers and babies',
        'benefits': 'Free checkups, free delivery, free medicines',
        'howToApply': 'Register at health center with Aadhar',
        'link': 'https://health.delhi.gov.in',
        'icon': '⚕️',
      },
    ],
  };

  final List<String> states = [
    'Goa',
    'Maharashtra',
    'Uttar Pradesh',
    'Karnataka',
    'Tamil Nadu',
    'Rajasthan',
    'Delhi',
  ];

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4B5E8),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'State Benefits',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Header Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.card_giftcard,
                        color: const Color(0xFFB794F4), size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Government Benefits',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover schemes available for expecting mothers',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // State Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: const Color(0xFFB794F4), size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Select Your State',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD4B5E8),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: selectedState,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: states.map((String state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedState = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Benefits List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Benefits in $selectedState',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                    stateBenefits[selectedState]!.length,
                        (index) => _buildBenefitCard(
                      stateBenefits[selectedState]![index],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard(Map<String, String> benefit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and scheme name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D5F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  benefit['icon']!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      benefit['scheme']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      benefit['description']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Benefits
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✓ ',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Benefits:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        benefit['benefits']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // How to Apply
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📋 ',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How to apply:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      benefit['howToApply']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Official Link Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _launchURL(benefit['link']!);
              },
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Official Link'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4B5E8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}