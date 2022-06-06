import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;
  const NewTransaction(this.addTransaction);
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // late String titleInput;
  // late String amountInput;
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? selectedDate = null;

  void submitted() {
    final titleContainer = titleController.text;
    final amountContainer = int.parse(amountController.text);
    if (amountController.text.isEmpty) {
      return;
    }
    if (titleContainer.isEmpty ||
        amountContainer <= 0 ||
        selectedDate == null) {
      return;
    }
    widget.addTransaction(titleContainer, amountContainer, selectedDate);
    Navigator.of(context).pop();
  }

  selectDatePicker(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime.now());
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                style: TextStyle(fontWeight: FontWeight.normal),
                onSubmitted: (_) => submitted(),

                // onChanged: (val) {
                //   titleInput = val;
                // },
                controller: titleController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                style: TextStyle(fontWeight: FontWeight.normal),
                keyboardType:
                    TextInputType.number, //does not work in modal sheet
                onSubmitted: (_) => submitted(),
                // onChanged: (val) {
                //   amountInput = val;
                // },
                controller: amountController,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        selectedDate == null
                            ? 'No date chosen!'
                            : 'Date chosen: ${DateFormat.yMd().format(selectedDate!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        selectDatePicker(context);
                      },
                      child: const Text('Choose date',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  child: const Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: submitted)
            ],
          ),
        ),
      ),
    );
  }
}
