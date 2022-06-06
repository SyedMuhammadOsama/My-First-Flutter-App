import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  Function deletefunction;
  final List TransactionBody;
  TransactionList(this.TransactionBody, this.deletefunction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: TransactionBody.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: [
                    Text(
                      "No transaction added yet",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/image/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              },
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text('Rs.${TransactionBody[index].amount}')),
                      ),
                    ),
                    title: Text(
                      TransactionBody[index].title,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    subtitle: Text(DateFormat.yMMMMd()
                        .format(TransactionBody[index].date)),
                    trailing: MediaQuery.of(context).size.width > 460
                        ? TextButton.icon(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                            ),
                            label: Text(
                              'Delete',
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                            onPressed: () =>
                                deletefunction(TransactionBody[index].id),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.delete,
                            ),
                            color: Theme.of(context).errorColor,
                            onPressed: () =>
                                deletefunction(TransactionBody[index].id),
                          ),
                  ),
                );
                // return Card(
                //   elevation: 5,
                //   margin: EdgeInsets.all(20),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         flex: 1,
                //         child: Container(
                //           margin: EdgeInsets.symmetric(
                //               vertical: 10, horizontal: 15),
                //           padding: EdgeInsets.all(7),
                //           decoration: BoxDecoration(
                //               border: Border.all(
                //                   color: Theme.of(context).primaryColorDark)),
                //           child: FittedBox(
                //             child: Text(
                //               'Rs. ${TransactionBody[index].amount}',
                //               style: const TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.teal,
                //                 fontSize: 20,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         flex: 2,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Container(
                //               padding: EdgeInsets.symmetric(
                //                   vertical: 2, horizontal: 3),
                //               child: Text(TransactionBody[index].title,
                //                   style: Theme.of(context).textTheme.subtitle1),
                //             ),
                //             Container(
                //               padding: EdgeInsets.symmetric(
                //                   vertical: 2, horizontal: 3),
                //               child: Text(
                //                 DateFormat.yMMMd()
                //                     .format(TransactionBody[index].date),
                //                 style: const TextStyle(
                //                     color: Colors.grey,
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.bold),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // );
              },
              itemCount: TransactionBody.length,
            ),
    );
  }
}
