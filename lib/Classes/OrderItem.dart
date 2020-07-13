class OrderItem {
  bool isCompleted;
  double orderAmount;
  List<String> itemsName;
  List<int> itemsQty;
  String dateTime,
      completedTime,
      shippedTime,
      status,
      orderNumber,
      orderKey,
      address,
      phNo;

  OrderItem(
      {this.isCompleted,
      this.itemsName,
      this.itemsQty,
      this.orderAmount,
      this.dateTime,
      this.shippedTime,
      this.completedTime,
      this.status,
      this.orderNumber,
      this.orderKey});
}
