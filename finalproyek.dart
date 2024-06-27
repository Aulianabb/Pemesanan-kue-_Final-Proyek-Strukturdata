import 'dart:io'; // untuk stdin
import 'dart:async'; // untuk Future

class Customer {
  String name;
  DateTime orderTime;
  String cakeName;
  int quantity; // jumlah kue yang dipesan
  int cakePrice;

  Customer(this.name, this.orderTime, this.cakeName, this.quantity, this.cakePrice);
}

class Cake {
  String name;
  int stock;
  int price;

  Cake(this.name, this.stock, this.price);
}

void main() {
  // Inisialisasi daftar kue
  List<Cake> cakes = [
    Cake("Brownies", 10, 6000),
    Cake("Strawberry Cheesecake", 5, 10000),
    Cake("Macaroni Schottel", 8, 8000),
    Cake("Cromboloni", 6, 25000),
    Cake("Mille Crepe", 7, 15000),
  ];

  // Inisialisasi antrian pemesanan
  List<Customer> orderQueue = [];

  // Daftar pemesanan yang telah diproses
  List<Customer> processedOrders = [];

  // Pemesanan
  void processOrders() {
    if (orderQueue.isNotEmpty) {
      Customer processedCustomer = orderQueue.removeAt(0);
      processedOrders.add(processedCustomer);
      print("Pemesanan ${processedOrders.length} atas nama ${processedCustomer.name} untuk kue ${processedCustomer.cakeName} (${processedCustomer.quantity} Pcs) seharga ${processedCustomer.cakePrice} IDR telah dikonfirmasi.");
    }
  }

  void editOrder() {
    if (orderQueue.isEmpty) {
      print("Tidak ada pesanan untuk diedit.");
      return;
    }

    print("Daftar pesanan saat ini:");
    for (int i = 0; i < orderQueue.length; i++) {
      Customer customer = orderQueue[i];
      print("${i + 1}. ${customer.name} memesan ${customer.cakeName} (${customer.quantity} Pcs) seharga ${customer.cakePrice} IDR");
    }

    print("Pilih nomor pesanan yang ingin diedit: ");
    int orderChoice = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
    if (orderChoice <= 0 || orderChoice > orderQueue.length) {
      print("Pilihan tidak valid.");
      return;
    }

    Customer chosenOrder = orderQueue[orderChoice - 1];

    print("Masukkan jumlah baru untuk kue ${chosenOrder.cakeName}: ");
    int newQuantity = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
    if (newQuantity <= 0 || newQuantity > chosenOrder.quantity + cakes.firstWhere((cake) => cake.name == chosenOrder.cakeName).stock) {
      print("Jumlah kue tidak valid atau melebihi stok tersedia.");
      return;
    }

    // Update stok kue
    Cake chosenCake = cakes.firstWhere((cake) => cake.name == chosenOrder.cakeName);
    chosenCake.stock += chosenOrder.quantity - newQuantity;

    // Update pesanan
    chosenOrder.quantity = newQuantity;

    print("Pesanan telah diperbarui: ${chosenOrder.name} memesan ${chosenOrder.cakeName} (${chosenOrder.quantity} Pcs) seharga ${chosenOrder.cakePrice} IDR.");
  }

  while (true) {
    print("Pilih opsi: ");
    print("1. Buat pesanan baru");
    print("2. Edit pesanan");
    print("3. Keluar");
    int choice = int.tryParse(stdin.readLineSync() ?? "") ?? 0;

    if (choice == 1) {
      print("Masukkan nama: ");
      String name = stdin.readLineSync() ?? "";

      print("Pilih kue: ");
      for (int i = 0; i < cakes.length; i++) {
        Cake cake = cakes[i];
        print("${i + 1}. ${cake.name} (stok: ${cake.stock}, harga: ${cake.price} IDR)");
      }

      int cakeChoice = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
      if (cakeChoice <= 0 || cakeChoice > cakes.length) {
        print("Pilihan kue tidak valid.");
        continue;
      }

      Cake chosenCake = cakes[cakeChoice - 1];

      // Periksa ketersediaan stok kue
      if (chosenCake.stock > 0) {
        print("Masukkan jumlah kue yang ingin dipesan: ");
        int quantity = int.tryParse(stdin.readLineSync() ?? "") ?? 0;
        if (quantity <= 0) {
          print("Jumlah kue tidak valid.");
          continue;
        }

        if (quantity > chosenCake.stock) {
          print("Maaf, stok kue ${chosenCake.name} tidak mencukupi.");
          continue;
        }

        chosenCake.stock -= quantity;
        Customer newCustomer = Customer(name, DateTime.now(), chosenCake.name, quantity, chosenCake.price);
        orderQueue.add(newCustomer);
        print("Pemesanan ${orderQueue.length} atas nama $name untuk kue ${chosenCake.name} (${quantity} Pcs) seharga ${chosenCake.price} IDR telah dikonfirmasi.");

        // Simulasikan pemrosesan pesanan setelah 5 detik
        Future.delayed(Duration(seconds: 5), processOrders);
      } else {
        print("Maaf, stok kue ${chosenCake.name} sudah habis.");
      }
    } else if (choice == 2) {
      editOrder();
    } else if (choice == 3) {
      break;
    } else {
      print("Pilihan tidak valid.");
    }
  }

  // Tampilkan antrian pemesanan yang telah diproses
  print("\nAntrian Pemesanan yang Telah Diproses:");
  for (Customer customer in processedOrders) {
    print("- ${customer.name} memesan ${customer.cakeName} (${customer.quantity} Pcs) seharga ${customer.cakePrice} IDR pada ${customer.orderTime}");
  }
}
