class Comission {
  final int id;
  final double amount;
  final double balance;
  final String userId;
  final String referralId;
  final String level;
  final String desc;
  final String ref;
  final DateTime createdAt;
  final String status;

  Comission({
    this.id,
    this.amount,
    this.balance,
    this.createdAt,
    this.desc,
    this.ref,
    this.level,
    this.referralId,
    this.userId,
    this.status,
  });

  factory Comission.fromMap(Map data) {
    return Comission(
      id: data['id'],
      amount: double.parse(data['amount']),
      balance: double.parse(data['balance']),
      desc: data['desc'],
      ref: data['ref'],
      referralId: data['referral_id'] ?? '',
      level: data['level'],
      userId: data['user_id'],
      createdAt: DateTime.parse(data['created_at']) ?? null,
      status: data['status'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount.toString(),
        'balance': balance.toString(),
        'desc': desc,
        'ref': ref,
        'referral_id': referralId,
        'level': level,
        'user_id': userId,
        'created_at': createdAt.toIso8601String(),
        'status': status,
      };
}
