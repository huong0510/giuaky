import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _tenSPController = TextEditingController();
  final TextEditingController _loaiController = TextEditingController();
  final TextEditingController _giaController = TextEditingController();

  final CollectionReference _sanpham =
      FirebaseFirestore.instance.collection("sanpham");

  void _addSanpham() {
    String id = _sanpham.doc().id;

    _sanpham.doc(id).set({
      'id': id,
      'TenSP': _tenSPController.text,
      'Gia': _giaController.text,
      'Loai': _loaiController.text,
    });

    _tenSPController.clear();
    _giaController.clear();
    _loaiController.clear();
  }

  void _deleteSanpham(String id) {
    _sanpham.doc(id).delete();
  }

  void _editSanpham(String id, String tenSP, String loai, String gia) {
    _tenSPController.text = tenSP;
    _loaiController.text = loai;
    _giaController.text = gia;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa sản phẩm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tenSPController,
                decoration: const InputDecoration(labelText: "Tên sản phẩm"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _loaiController,
                decoration: const InputDecoration(labelText: "Loại sản phẩm"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _giaController,
                decoration: const InputDecoration(labelText: "Giá sản phẩm"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                _sanpham.doc(id).update({
                  'TenSP': _tenSPController.text,
                  'Loai': _loaiController.text,
                  'Gia': _giaController.text,
                }).then((value) {
                  Navigator.of(context).pop();
                  _tenSPController.clear();
                  _giaController.clear();
                  _loaiController.clear();
                });
              },
              child: const Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "Dữ Liệu Sản Phẩm",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _tenSPController,
              decoration: const InputDecoration(labelText: "Nhập tên sản phẩm"),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _loaiController,
              decoration:
                  const InputDecoration(labelText: "Nhập loại sản phẩm"),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _giaController,
              decoration: const InputDecoration(labelText: "Nhập giá sản phẩm"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                _addSanpham();
              },
              child: const Text("Thêm Sản Phẩm"),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
                child: StreamBuilder(
                    stream: _sanpham.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var sanpham = snapshot.data!.docs[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tên sản phẩm: ${sanpham['TenSP']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Loại: ${sanpham['Loai']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Giá sản phẩm: ${sanpham['Gia']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _deleteSanpham(sanpham['id']);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _editSanpham(
                                              sanpham['id'],
                                              sanpham['TenSP'],
                                              sanpham['Loai'],
                                              sanpham['Gia'],
                                            );
                                          },
                                          icon: const Icon(Icons.edit),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
