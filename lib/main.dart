import 'package:flutter/material.dart';

void main() {
  runApp(const DamkarApp());
}

class DamkarApp extends StatelessWidget {
  const DamkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Damkar',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Data laporan
  List<Map<String, dynamic>> laporanList = [
    {
      'id': 'L001',
      'lokasi': 'Jl. Sudirman No. 123',
      'jenis': 'Kebakaran Rumah',
      'waktu': '10:30',
      'tanggal': '20 Nov 2023',
      'status': 'proses',
      'petugas': 'Tim A'
    },
    {
      'id': 'L002',
      'lokasi': 'Pasar Induk',
      'jenis': 'Kebakaran Pasar',
      'waktu': '14:00',
      'tanggal': '19 Nov 2023',
      'status': 'selesai',
      'petugas': 'Tim B'
    },
    {
      'id': 'L003',
      'lokasi': 'Gedung Perkantoran',
      'jenis': 'Kebakaran Gedung',
      'waktu': '08:15',
      'tanggal': '21 Nov 2023',
      'status': 'menunggu',
      'petugas': 'Tim C'
    },
  ];

  // Data petugas
  List<Map<String, dynamic>> petugasList = [
    {
      'id': 'P001',
      'nama': 'Budi Santoso',
      'pangkat': 'Letnan',
      'unit': 'Pemadam',
      'tugas': true
    },
    {
      'id': 'P002',
      'nama': 'Siti Rahayu',
      'pangkat': 'Sersan',
      'unit': 'Penyelamat',
      'tugas': true
    },
    {
      'id': 'P003',
      'nama': 'Ahmad Fauzi',
      'pangkat': 'Kapten',
      'unit': 'Pemimpin',
      'tugas': false
    },
  ];

  // Data tips
  List<Map<String, String>> tipsList = [
    {'title': 'Pencegahan', 'desc': 'Periksa instalasi listrik rutin'},
    {'title': 'APAR', 'desc': 'Sediakan alat pemadam kebakaran'},
    {'title': 'Nomor Darurat', 'desc': 'Hafalkan 113 untuk damkar'},
    {'title': 'Evakuasi', 'desc': 'Tentukan titik kumpul'},
    {'title': 'Asap', 'desc': 'Merangkak jika asap tebal'},
  ];

  // Fungsi untuk dashboard
  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          const Text(
            'Dashboard Damkar',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Statistik
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBox('Total', '${laporanList.length}', Colors.blue),
              _buildStatBox('Proses', '2', Colors.orange),
              _buildStatBox('Selesai', '1', Colors.green),
            ],
          ),

          const SizedBox(height: 20),

          // Tombol Darurat
          Card(
            color: Colors.red.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.emergency, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  const Text(
                    'DARURAT KEBAKARAN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const Text('Hubungi: 113'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('LAPOR DARURAT'),
                          content: const Text('Apakah Anda yakin? Tim akan dikirim!'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () {
                                Navigator.pop(context);
                                // Tambah laporan darurat
                                _addLaporanDarurat();
                              },
                              child: const Text('LAPORKAN', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('LAPOR DARURAT', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Laporan Terbaru
          const Text(
            'Laporan Terbaru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ...laporanList.take(3).map((laporan) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  laporan['status'] == 'proses' ? Icons.fire_truck : 
                  laporan['status'] == 'selesai' ? Icons.check_circle : Icons.access_time,
                  color: laporan['status'] == 'proses' ? Colors.red : 
                        laporan['status'] == 'selesai' ? Colors.green : Colors.orange,
                ),
                title: Text(laporan['jenis']),
                subtitle: Text(laporan['lokasi']),
                trailing: Chip(
                  label: Text(
                    laporan['status'],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: laporan['status'] == 'proses' ? Colors.red : 
                                  laporan['status'] == 'selesai' ? Colors.green : Colors.orange,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        const SizedBox(height: 5),
        Text(title),
      ],
    );
  }

  void _addLaporanDarurat() {
    setState(() {
      String newId = 'L00${laporanList.length + 1}';
      laporanList.insert(0, {
        'id': newId,
        'lokasi': 'Lokasi Darurat',
        'jenis': 'KEBAKARAN DARURAT',
        'waktu': 'NOW',
        'tanggal': 'Sekarang',
        'status': 'proses',
        'petugas': 'TIM DARURAT'
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan darurat telah dikirim! Tim sedang menuju lokasi.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Fungsi untuk halaman laporan
  Widget _buildLaporanPage() {
    return Scaffold(
      body: laporanList.isEmpty
          ? const Center(child: Text('Belum ada laporan'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: laporanList.length,
              itemBuilder: (context, index) {
                var laporan = laporanList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(
                      laporan['status'] == 'proses' ? Icons.fire_truck : 
                      laporan['status'] == 'selesai' ? Icons.check_circle : Icons.access_time,
                      color: laporan['status'] == 'proses' ? Colors.red : 
                            laporan['status'] == 'selesai' ? Colors.green : Colors.orange,
                    ),
                    title: Text(laporan['jenis']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(laporan['lokasi']),
                        Text('${laporan['tanggal']} ${laporan['waktu']}'),
                        Text('Petugas: ${laporan['petugas']}'),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        laporan['status'],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: laporan['status'] == 'proses' ? Colors.red : 
                                      laporan['status'] == 'selesai' ? Colors.green : Colors.orange,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLaporanDialog();
        },
        child: const Icon(Icons.add_alert),
      ),
    );
  }

  void _showAddLaporanDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController lokasiController = TextEditingController();
        String? selectedJenis = 'Kebakaran Rumah';

        return AlertDialog(
          title: const Text('Buat Laporan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: lokasiController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedJenis,
                decoration: const InputDecoration(
                  labelText: 'Jenis Kejadian',
                  border: OutlineInputBorder(),
                ),
                items: ['Kebakaran Rumah', 'Kebakaran Gedung', 'Kebakaran Pabrik', 'Lainnya']
                    .map((jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedJenis = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (lokasiController.text.isNotEmpty) {
                  setState(() {
                    String newId = 'L00${laporanList.length + 1}';
                    laporanList.insert(0, {
                      'id': newId,
                      'lokasi': lokasiController.text,
                      'jenis': selectedJenis!,
                      'waktu': '${DateTime.now().hour}:${DateTime.now().minute}',
                      'tanggal': '${DateTime.now().day} Nov ${DateTime.now().year}',
                      'status': 'menunggu',
                      'petugas': 'Tim Standby'
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk halaman petugas
  Widget _buildPetugasPage() {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: petugasList.length,
        itemBuilder: (context, index) {
          var petugas = petugasList[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: petugas['tugas'] ? Colors.red.shade100 : Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  color: petugas['tugas'] ? Colors.red : Colors.grey,
                ),
              ),
              title: Text(
                petugas['nama'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pangkat: ${petugas['pangkat']}'),
                  Text('Unit: ${petugas['unit']}'),
                ],
              ),
              trailing: Switch(
                value: petugas['tugas'],
                onChanged: (value) {
                  setState(() {
                    petugasList[index]['tugas'] = value;
                  });
                },
                activeColor: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }

  // Fungsi untuk halaman info
  Widget _buildInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips Pencegahan Kebakaran',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ...tipsList.map((tip) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.tips_and_updates, color: Colors.orange),
                title: Text(tip['title']!),
                subtitle: Text(tip['desc']!),
              ),
            );
          }).toList(),

          const SizedBox(height: 20),

          const Text(
            'Nomor Darurat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Card(
            color: Colors.red.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.emergency, size: 50, color: Colors.red),
                  SizedBox(height: 10),
                  Text(
                    '113',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Text('Pemadam Kebakaran'),
                  SizedBox(height: 20),
                  Text(
                    '112',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Text('Darurat Umum'),
                  SizedBox(height: 10),
                  Text(
                    '119',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Text('Ambulans'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Prosedur Darurat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Tetap tenang, jangan panik'),
                  SizedBox(height: 5),
                  Text('2. Hubungi Damkar (113)'),
                  SizedBox(height: 5),
                  Text('3. Matikan sumber listrik'),
                  SizedBox(height: 5),
                  Text('4. Gunakan APAR jika bisa'),
                  SizedBox(height: 5),
                  Text('5. Evakuasi diri dan orang lain'),
                  SizedBox(height: 5),
                  Text('6. Tunggu di titik kumpul'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Damkar'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Petugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildLaporanPage();
      case 2:
        return _buildPetugasPage();
      case 3:
        return _buildInfoPage();
      default:
        return _buildDashboard();
    }
  }
}