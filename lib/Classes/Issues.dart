class Issues {
  String completedTime,
      placedTime,
      desc,
      request,
      status,
      orderAmount,
      address,
      orderNumber,
      orderKey,
      phNo;
  List<String> itemsName;
  List<int> itemsQty;

  Issues(
      {this.request,
      this.completedTime,
      this.orderAmount,
      this.itemsQty,
      this.itemsName,
      this.status,
      this.desc,
      this.placedTime,
      this.phNo,
      this.address,
      this.orderKey,
      this.orderNumber});
}
