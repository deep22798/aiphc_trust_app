import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> onWillPop() async {
  return await Get.bottomSheet<bool>(
    SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
             Text(
              "Exit App?",
              style: TextStyle(
                fontSize: 18,color: Colors.black,

                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
      
            const Text(
             "Are you sure you want to close the app?",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    child:  Text("Stay",style: TextStyle(color: Colors.black),),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => Get.back(result: true),
                    child:  Text("Exit",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    isDismissible: false,
  ) ??
      false;
}
