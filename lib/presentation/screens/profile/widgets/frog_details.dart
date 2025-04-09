import 'package:flutter/material.dart';
import '../../../../domain/entities/frog.dart';

class FrogDetails extends StatelessWidget {
  final FrogData frogData;
  final TextEditingController frogNameController;
  final bool isEditingFrogName;
  final VoidCallback onEditToggle;
  final VoidCallback onSaveFrogName;

  const FrogDetails({
    super.key,
    required this.frogData,
    required this.frogNameController,
    required this.isEditingFrogName,
    required this.onEditToggle,
    required this.onSaveFrogName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Ім'я жаби:", style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(width: 10),
              isEditingFrogName
                  ? Expanded(
                child: TextField(
                  controller: frogNameController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              )
                  : Expanded(
                child: Text(
                  frogData.frogName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isEditingFrogName ? Icons.check : Icons.edit,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () {
                  if (isEditingFrogName) {
                    onSaveFrogName();
                  }
                  onEditToggle();
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildStatRow("Лизів за сьогодні:", frogData.dayLicks),
          const SizedBox(height: 10),
          _buildStatRow("Лизів за весь час:", frogData.allLicks),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
        const Spacer(),
        Text(
          "$value",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
