import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/main.dart';

class CommonWidgets {

  void confirmDelete({
    required BuildContext context,
    required String id,
    required String title, 
    required String type,  
    required Function(String) onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: primary,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text("Delete $title?", 
                style: TextStyle(color: secondary, fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        content: Text(
          "This action cannot be undone. Are you sure you want to delete this $type?",
          style: TextStyle(color: secondary.withValues(alpha: 0.8), fontSize: 16),
        ),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", 
              style: TextStyle(color: secondary.withValues(alpha: 0.6), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, 
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              onConfirm(id); 
              Navigator.pop(ctx); 
            },
            child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void showDialogs(BuildContext context, String title,String tag,String btn, Function(String) onConfirm) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: TextStyle(color: secondary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag,
              style: TextStyle(color: secondary.withValues(alpha: .6), fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(

              controller: controller,
              autofocus: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z_0-9 ]')),
                FilteringTextInputFormatter.deny(RegExp(r'^\s+'), ),
              ],
              
              decoration: InputDecoration(
                
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondary.withValues(alpha: .2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: sageGreen, width: 2),
                ),
              ),
            ),
          ],
        ),
        
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel", style: TextStyle(color: secondary.withValues(alpha: 0.5)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: sageGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
            onPressed: () { 
              if(controller.text.trim().isNotEmpty){
              onConfirm(controller.text); Navigator.pop(ctx); 

              }
              }, 
            child:  Text(btn),
          ),
        ],
      ),
    );
  }

}