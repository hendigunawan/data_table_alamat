import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

String baseUrl = 'https://dev.farizdotid.com/api/daerahindonesia/';
String baseUrlN = 'https://countriesnow.space/api/v0.1/countries/codes';
String keyAppID = 'M4fYLnVzKtJU4O2kbZ9zahl1Y1fTTP2edzr8nVMn';
String clientKey = 'VvROI34CJdsKLg7HhnCrjPzycBOp7Baxp2Y4ItBU';
String keyPServerUrl = 'https://parseapi.back4app.com';

List<DataColumn> tableColumn = [
  const DataColumn(
    label: Text('Nama Jalan'),
  ),
  const DataColumn(
    label: Text('Kecamatan'),
  ),
  const DataColumn(
    label: Text('Kelurahan'),
  ),
  const DataColumn(
    label: Text('Kota'),
  ),
  const DataColumn(
    label: Text('Provinsi'),
  ),
  const DataColumn(
    label: Text('Negara'),
  ),
  const DataColumn(
    label: Text('Kategori'),
  ),
  const DataColumn(
    label: Text('Status'),
  ),
  const DataColumn(
    label: Text('Detail'),
  ),
];
InputD({
  TextEditingController? controller,
  Widget? icon,
  String? label,
  String? hint,
  double? height,
  double? width,
  bool isCollapsed = false,
  EdgeInsetsGeometry? padding,
}) {
  return Container(
    padding: padding,
    height: height,
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null ? Text('$label') : const SizedBox(),
        TextField(
          textAlign: TextAlign.justify,
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          decoration: InputDecoration(
            isCollapsed: isCollapsed,
            prefixIcon: icon,
            hintText: '$hint',
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    ),
  );
}

DropD({
  List<DropdownMenuItem<dynamic>>? items,
  Function(dynamic)? onChanged,
  Function()? onTap,
  String? textT,
  String? textH,
  value,
}) {
  return Container(
    padding: const EdgeInsets.all(8),
    height: 85,
    width: 200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textT.toString(),
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              borderRadius: BorderRadius.circular(10),
              isExpanded: true,
              onTap: onTap,
              items: items,
              onChanged: onChanged,
              value: value,
              hint: Text(textH.toString()),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> saveData(
    String idkategori,
    String idnegara,
    String idprovinsi,
    String idkota,
    String idkecamatan,
    String idkelurahan,
    String kategori,
    String negara,
    String provinsi,
    String kota,
    String kecamatan,
    String kelurahan,
    String kopost,
    String najalan,
    String rt,
    String rw,
    String nt,
    bool activ,
    object) async {
  final save = ParseObject(object)
    ..set('kategori', kategori)
    ..set('negara', negara)
    ..set('provinsi', provinsi)
    ..set('kota', kota)
    ..set('kecamatan', kecamatan)
    ..set('kelurahan', kelurahan)
    ..set('kodePost', kopost)
    ..set('namaJalan', najalan)
    ..set('RT', rt)
    ..set('RW', rw)
    ..set('idkategori', idkategori)
    ..set('idnegara', idnegara)
    ..set('idprovinsi', idprovinsi)
    ..set('idkota', idkota)
    ..set('idkecamatan', idkecamatan)
    ..set('idkelurahan', idkelurahan)
    ..set('Active', activ);

  await save.save();
}

Future<List<ParseObject>> getDataTable(object) async {
  QueryBuilder<ParseObject> queryTodo =
      QueryBuilder<ParseObject>(ParseObject(object));
  final ParseResponse apiResponse = await queryTodo.query();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

Future<void> deleteRow(String id, String nameTable) async {
  var todo = ParseObject(nameTable)..objectId = id;
  await todo.delete();
}
