import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_code_bloc/models/product_model.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestrore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<ProductModel>> getAllProducts() async* {
    yield* firestrore
        .collection("products")
        .withConverter<ProductModel>(
          fromFirestore: (snapshot, _) =>
              ProductModel.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductStateInitial()) {
    on<ProductEventAddProduct>((event, emit) async {
      //Tambah product ke db
      try {
        emit(ProductStateLoadingAdd());

        //tambah data
        var hasil = await firestrore.collection("products").add({
          "code": event.code,
          "nama": event.nama,
          "qty": event.qty,
        });

        await firestrore
            .collection("products")
            .doc(hasil.id)
            .update({"productId": hasil.id});

        emit(ProductStateCompleteAdd());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak Dapat Menambah Product"));
      } catch (e) {
        emit(ProductStateError("Tidak Dapat Menambah Product"));
      }
    });
    on<ProductEventEditProduct>((event, emit) async {
      //Edit product ke db
      try {
        emit(ProductStateLoadingEdit());

        await firestrore.collection("products").doc(event.id).update({
          "nama": event.nama,
          "qty": event.qty,
          "productId": event.id,
        });

        emit(ProductStateCompleteEdit());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak Dapat Menambah Product"));
      } catch (e) {
        emit(ProductStateError("Tidak Dapat Menambah Product"));
      }
    });
    on<ProductEventDeleteProduct>((event, emit) async {
      //hapus product ke db
      try {
        emit(ProductStateLoadingDelete());

        await firestrore.collection("products").doc(event.id).delete();

        emit(ProductStateCompleteDelete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak Dapat Hapus Product"));
      } catch (e) {
        emit(ProductStateError("Tidak Dapat Hapus Product"));
      }
    });

    on<ProductEventExportPdf>((event, emit) async {
      //Export PDF
      try {
        emit(ProductStateLoadingExport());
        var querySnap = await firestrore
            .collection("products")
            .withConverter<ProductModel>(
              fromFirestore: (snapshot, _) =>
                  ProductModel.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();

        List<ProductModel> allProduct = [];
        for (var element in querySnap.docs) {
          ProductModel product = element.data();
          allProduct.add(product);
        }

        final pdf = pw.Document();

        //Masukin data ke pdf
        var data =
            await rootBundle.load("assets/fonts/opensans/OpenSans-Regular.ttf");
        var myFont = pw.Font.ttf(data);
        var myStyle = pw.TextStyle(font: myFont);

        pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            List<pw.TableRow> allData = List.generate(
              allProduct.length,
              (index) {
                ProductModel product = allProduct[index];
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "${index + 1}",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "${product.code}",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        product.nama.toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "${product.qty}",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: myFont,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.BarcodeWidget(
                        color: PdfColor.fromHex("#000000"),
                        barcode: pw.Barcode.qrCode(),
                        data: product.code.toString(),
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ],
                );
              },
            );
            return [
              pw.Center(
                child: pw.Text(
                  "CATALOG PRODUCT",
                  style: pw.TextStyle(
                    font: myFont,
                    fontSize: 24,
                  ),
                ),
              ),
              pw.SizedBox(
                height: 20.0,
              ),
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColor.fromHex("#000000"),
                ),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "No",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: myFont,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "Product Code",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: myFont,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "Product Name",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "Qty",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: myFont,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          "QR Code",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: myFont,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //ISI DATANYA
                  ...allData
                ],
              ),
            ];
          },
        ));

        Uint8List bytes = await pdf.save();

        //Open File
        final dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/Data-Product.pdf");

        //Masukkin data bytes ke file pdf
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);
        emit(ProductStateCompleteExport());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak Dapat Export PDF"));
      } catch (e) {
        emit(ProductStateError("Tidak Dapat Export PDF"));
      }
    });
  }
}
