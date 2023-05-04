import 'dart:convert';
import 'package:data_table_alamat/constan.dart';
import 'package:data_table_alamat/loading/loading_screens.dart';
import 'package:line_icons/line_icons.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    keyAppID,
    keyPServerUrl,
    clientKey: clientKey,
    autoSendSessionId: true,
  );
  runApp(const MaterialApp(
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool form = false;
  bool activ = false;
  String? kategori;
  String? kategori1;
  String? negara;
  String? provinsi;
  String? kota;
  String? kecamatan;
  String? kelurahan;
  late TextEditingController kP = TextEditingController();
  late TextEditingController nJ = TextEditingController();
  late TextEditingController rT = TextEditingController();
  late TextEditingController rW = TextEditingController();
  late TextEditingController nT = TextEditingController();
  @override
  void initState() {
    super.initState();
    getProvince();
    getNegara();
    getKota(idProvinsi);
    getKecamatan(idKota);
    getKelurahan(idKecamatan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputD(
                    isCollapsed: true,
                    width: 600,
                    height: 40,
                    hint: 'Search',
                    icon: const Icon(Icons.search),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: SizedBox(
                      width: 130,
                      height: 40,
                      child: Row(
                        children: const [
                          Icon(Icons.filter_alt_outlined),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Filter'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        form = true;
                      });
                    },
                    child: SizedBox(
                      width: 130,
                      height: 40,
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          SizedBox(
                            width: 15,
                          ),
                          Text('ADD DATA'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              form == true ? FormAdd() : Container(),
              FutureBuilder(
                future: getDataTable('alamat'),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Container(
                            width: 100,
                            height: 100,
                            child: const CircularProgressIndicator()),
                      );
                    default:
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Error..."),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No Data..."),
                        );
                      } else {
                        return SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            columns: tableColumn,
                            rows: List.generate(
                              snapshot.data!.length,
                              ((index) => DataRow(
                                    cells: [
                                      DataCell(Text(snapshot.data![index]
                                          .get("namaJalan")
                                          .toString())),
                                      DataCell(Text(snapshot.data![index]
                                          .get("kecamatan")
                                          .toString())),
                                      DataCell(Text(snapshot.data![index]
                                          .get("kelurahan")
                                          .toString())),
                                      DataCell(Text(snapshot.data![index]
                                          .get("kota")
                                          .toString())),
                                      DataCell(Text(snapshot.data![index]
                                          .get("provinsi")
                                          .toString())),
                                      DataCell(Text(snapshot.data![index]
                                          .get("negara")
                                          .toString())),
                                      DataCell(Text(snapshot.data![index]
                                          .get("kategori")
                                          .toString())),
                                      DataCell(Text(snapshot.data![index]
                                          .get("Active")
                                          .toString())),
                                      DataCell(
                                        Row(
                                          children: [
                                            TextButton(
                                              child: Icon(
                                                LineIcons.eye,
                                                size: 18,
                                                color: Colors.orange[300],
                                              ),
                                              onPressed: () {},
                                            ),
                                            TextButton(
                                              child: const Icon(
                                                LineIcons.trash,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: Center(
                                                        child: Column(
                                                          children: const [
                                                            Icon(
                                                                Icons
                                                                    .warning_outlined,
                                                                size: 36,
                                                                color:
                                                                    Colors.red),
                                                            SizedBox(
                                                                height: 20),
                                                            Text(
                                                                "Confirm Deletion"),
                                                          ],
                                                        ),
                                                      ),
                                                      content: Container(
                                                        height: 70,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                "Are you sure want to delete '${snapshot.data![index].get("namaJalan").toString()}'?"),
                                                            const SizedBox(
                                                              height: 16,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton
                                                                    .icon(
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              14,
                                                                        ),
                                                                        style: ElevatedButton.styleFrom(
                                                                            primary: Colors
                                                                                .grey),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        label: const Text(
                                                                            "Cancel")),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                ElevatedButton
                                                                    .icon(
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 14,
                                                                  ),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary:
                                                                              Colors.red),
                                                                  onPressed:
                                                                      () async {
                                                                    await deleteRow(
                                                                        snapshot
                                                                            .data![index]
                                                                            .get('objectId')
                                                                            .toString(),
                                                                        'alamat');
                                                                    print(snapshot
                                                                        .data![
                                                                            index]
                                                                        .get(
                                                                            'objectId')
                                                                        .toString());
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    setState(
                                                                        () {
                                                                      const snackBar =
                                                                          SnackBar(
                                                                        content:
                                                                            Text("deleted Sukses!"),
                                                                        duration:
                                                                            Duration(seconds: 2),
                                                                      );
                                                                      ScaffoldMessenger.of(
                                                                          context)
                                                                        ..removeCurrentSnackBar()
                                                                        ..showSnackBar(
                                                                            snackBar);
                                                                    });
                                                                  },
                                                                  label: const Text(
                                                                      "Delete"),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              // Delete
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        );
                      }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget FormAdd() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropD(
              textH: 'Kategori',
              textT: 'Kategori',
              items: [
                DropdownMenuItem(
                  child: const Text('Home'),
                  value: '1',
                  onTap: () {
                    setState(() {
                      nKate = 'Home';
                    });
                  },
                ),
                DropdownMenuItem(
                  child: const Text('Office'),
                  value: '2',
                  onTap: () {
                    setState(() {
                      nKate = 'Office';
                    });
                  },
                ),
                DropdownMenuItem(
                  child: const Text('school'),
                  value: '2',
                  onTap: () {
                    setState(() {
                      nKate = 'School';
                    });
                  },
                ),
              ],
              value: kategori,
              onChanged: (_) {
                kategori = _;
                setState(() {});
              },
            ),
            DropD(
              textT: 'Provinsi',
              textH: 'Provinsi',
              items: _dataProvince
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(
                        e['nama'].toString(),
                      ),
                      value: e['id'].toString(),
                      onTap: () {
                        provinsi = e['nama'].toString();
                      },
                    ),
                  )
                  .toList(),
              value: idProvinsi,
              onChanged: (value) async {
                idProvinsi = value;
                getKota(value);
                setState(() {});
              },
              onTap: () {
                if (idKota != null) {
                  print('DiKota');
                  setState(() {
                    _dataKota.clear();
                    idKota = null;
                    kota = null;
                    _dataKecamatan.clear();
                    idKecamatan = null;
                    kecamatan = null;
                    _dataKelurahan.clear();
                    idKelurahan = null;
                    kelurahan = null;
                  });
                }
              },
            ),
            DropD(
              textH: 'Kecamatan',
              textT: 'Kecamatan',
              value: idKecamatan,
              items: _dataKecamatan
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(e['nama'].toString()),
                      value: e['id'].toString(),
                      onTap: () => kecamatan = e['nama'].toString(),
                    ),
                  )
                  .toList(),
              onChanged: (_) {
                idKecamatan = _;
                getKelurahan(_);
                setState(() {});
              },
              onTap: () {
                if (idKota != null) {
                  print('DiKecamatan');
                  setState(() {
                    _dataKelurahan.clear();
                    idKelurahan = null;
                    kelurahan = null;
                  });
                }
              },
            ),
            InputD(
              label: 'Kode Post',
              hint: 'Kode Post',
              controller: kP,
              height: 85,
              width: 200,
              padding: const EdgeInsets.all(8),
            ),
            InputD(
              label: 'RT',
              hint: 'RT',
              controller: rT,
              width: 100,
              height: 85,
              padding: const EdgeInsets.all(8),
            ),
            InputD(
              label: 'RW',
              hint: 'RW',
              controller: rW,
              width: 100,
              height: 85,
              padding: const EdgeInsets.all(8),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropD(
              textH: 'Negara',
              textT: 'Negara',
              value: idNegara,
              onChanged: (_) {
                idNegara = _;
                setState(() {});
              },
              items: _dataNegara.map((e) {
                return DropdownMenuItem(
                  child: Text(
                    e['name'].toString(),
                  ),
                  value: e['dial_code'].toString(),
                  onTap: () => negara = e['name'].toString(),
                );
              }).toList(),
            ),
            DropD(
              textT: 'Kota',
              textH: 'Kota',
              items: _dataKota
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(
                        e['nama'].toString(),
                      ),
                      value: e['id'].toString(),
                      onTap: () => kota = e['nama'].toString(),
                    ),
                  )
                  .toList(),
              value: idKota,
              onChanged: (value) {
                idKota = value;
                getKecamatan(value);
                setState(() {});
              },
              onTap: () {
                if (idKecamatan != null) {
                  print('DiKota');
                  setState(() {
                    _dataKecamatan.clear();
                    idKecamatan = null;
                    kecamatan = null;
                    _dataKelurahan.clear();
                    idKelurahan = null;
                    kelurahan = null;
                  });
                }
              },
            ),
            DropD(
              textT: 'Kelurahan',
              textH: 'Kelurahan',
              items: _dataKelurahan
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(
                        e['nama'].toString(),
                      ),
                      value: e['id'].toString(),
                      onTap: () => kelurahan = e['nama'].toString(),
                    ),
                  )
                  .toList(),
              value: idKelurahan,
              onChanged: (value) {
                idKelurahan = value;
                // getKecamatan(value);
                setState(() {});
              },
              onTap: () {
                if (idKecamatan != null) {
                  print('DiKelurahan');
                  setState(() {
                    // _dataKecamatan.clear();
                    // idKecamatan = null;
                  });
                }
              },
            ),
            InputD(
              label: 'Nama Jalanan',
              hint: 'Nama Jalanan',
              controller: nJ,
              height: 85,
              width: 200,
              padding: const EdgeInsets.all(8),
            ),
            InputD(
              label: 'Nomer Telpon',
              hint: 'Nomer Telpon',
              controller: nT,
              height: 85,
              width: 200,
              padding: const EdgeInsets.all(8),
            ),
          ],
        ),
        SizedBox(
          width: 100,
          child: CheckboxMenuButton(
            value: activ,
            onChanged: (_) {
              activ = _ as bool;
              setState(() {});
            },
            child: const Text('Active'),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    form = false;
                  });
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                  side: const BorderSide(),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 118, 253),
                  side: const BorderSide(),
                ),
                onPressed: () async {
                  LoadingScreen().show(
                    context: context,
                    text: 'Mohon Tunggu!!!',
                  );
                  await Future.delayed(
                    const Duration(seconds: 3),
                  );
                  saveData(
                    kategori.toString(),
                    idNegara.toString(),
                    idProvinsi.toString(),
                    idKota.toString(),
                    idKecamatan.toString(),
                    idKelurahan.toString(),
                    nKate.toString(),
                    negara.toString(),
                    provinsi.toString(),
                    kota.toString(),
                    kecamatan.toString(),
                    kelurahan.toString(),
                    kP.value.text.toString(),
                    nJ.value.text.toString(),
                    rT.value.text.toString(),
                    rW.value.text.toString(),
                    nT.value.text.toString(),
                    activ,
                    'alamat',
                  );

                  idKecamatan = null;
                  idKelurahan = null;
                  idKota = null;
                  idNegara = null;
                  idProvinsi = null;
                  nKate = null;
                  kategori = null;
                  nJ.clear();
                  nT.clear();
                  rT.clear();
                  rW.clear();
                  kP.clear();
                  _dataKecamatan.clear();
                  _dataKelurahan.clear();
                  _dataKota.clear();
                  _dataNegara.clear();
                  _dataProvince.clear();

                  setState(() {
                    form = false;
                  });
                  LoadingScreen().hide();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  List _dataProvince = [];
  String? idProvinsi;

  void getProvince() async {
    final respose = await http.get(
      Uri.parse('${baseUrl}provinsi'),
    );
    var listData = jsonDecode(respose.body)['provinsi'];
    // print("data : $listData");
    setState(() {
      _dataProvince = listData;
    });
  }

  List _dataKota = [];
  String? idKota;
  void getKota(idProvinsi1) async {
    final respose = await http.get(
      Uri.parse('${baseUrl}kota?id_provinsi=${idProvinsi1}'),
    );
    var listData = jsonDecode(respose.body)['kota_kabupaten'];
    // print("data : $listData");
    setState(() {
      _dataKota = listData;
    });
  }

  List _dataKecamatan = [];
  String? idKecamatan;
  void getKecamatan(idKota1) async {
    final respose = await http.get(
      Uri.parse('${baseUrl}kecamatan?id_kota=$idKota1'),
    );
    var listData = jsonDecode(respose.body)['kecamatan'];
    // print("data : $listData");
    setState(() {
      _dataKecamatan = listData;
    });
  }

  List _dataKelurahan = [];
  String? idKelurahan;
  void getKelurahan(idKecamatan1) async {
    final respose = await http.get(
      Uri.parse('${baseUrl}kelurahan?id_kecamatan=$idKecamatan1'),
    );
    var listData = jsonDecode(respose.body)['kelurahan'];
    // print("data : $listData");
    setState(() {
      _dataKelurahan = listData;
    });
  }

  List _dataNegara = [];
  String? idNegara;
  void getNegara() async {
    final respose = await http.get(
      Uri.parse('$baseUrlN'),
    );
    var listData = jsonDecode(respose.body)['data'];
    // print("data : $listData");
    setState(() {
      _dataNegara = listData;
      // print('Data: $_dataNegara');
    });
  }

  String? nKate;
}
