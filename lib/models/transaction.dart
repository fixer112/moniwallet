class Transaction {
  final int id;
  final double amount;
  final double balance;
  final String type;
  final String userId;
  final String desc;
  final String reason;
  final bool isOnline;
  final String ref;
  final DateTime createdAt;

  Transaction({
    this.id,
    this.amount,
    this.balance,
    this.createdAt,
    this.desc,
    this.isOnline,
    this.reason,
    this.ref,
    this.type,
    this.userId,
  });

  factory Transaction.fromMap(Map data) {
    return Transaction(
      id: data['id'],
      amount: double.parse(data['amount'].toString()),
      balance: double.parse(data['balance'].toString()),
      desc: data['desc'],
      isOnline: data['is_online'] == '1' ? true : false,
      reason: data['reason'],
      type: data['type'],
      ref: data['ref'],
      userId: data['user_id'],
      createdAt: DateTime.parse(data['created_at']) ?? null,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount.toString(),
        'balance': balance.toString(),
        'desc': desc,
        'is_online': isOnline ? '1' : '0',
        'reason': reason,
        'type': type,
        'ref': ref,
        'user_id': userId,
        'created_at': createdAt.toIso8601String(),
      };
}
