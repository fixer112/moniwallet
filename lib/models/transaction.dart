class Transaction {
  final int id;
  final double amount;
  final double balance;
  final String type;
  final String userId;
  final String desc;
  final String reason;
  final bool isOnline;
  final String status;
  final String ref;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.balance,
    required this.createdAt,
    required this.desc,
    required this.isOnline,
    required this.reason,
    required this.ref,
    required this.type,
    required this.userId,
    required this.status,
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
      createdAt: DateTime.parse(data['created_at']),
      status: data['status'],
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
        'status': status,
      };
}
