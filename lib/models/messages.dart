import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:minka/variable.dart';

class Message {
  final String text;
  final String image;
  DateTime? sendDate;
  final String senderId;
  final String destId;
  String? idMessage;

  Message(
      {required this.senderId,
      required this.destId,
      required this.image,
      required this.text,
      this.idMessage,
      this.sendDate});

  Future<void> sendMessage() async {
    try {
      String monTchat = "$senderId$destId";
      String sonTchat = "$destId$senderId";
      String idMessage = chatCollection.doc().id;
      final inbox =
          chatCollection.doc(senderId).collection("Chat").doc(monTchat);
      final hebox = chatCollection.doc(destId).collection("Chat").doc(sonTchat);
      inbox.get().then((value) async {
        if (value.exists) {
          inbox.update({
            "MessagesNonLus": FieldValue.increment(1),
            "Texte": text,
            "Image": image,
            'SendTime': FieldValue.serverTimestamp(),
            'SenderId': senderId,
            "Destinataire": destId,
          });

          hebox.update({
            "MessagesNonLus": FieldValue.increment(1),
            "Texte": text,
            "Image": image,
            'SendTime': FieldValue.serverTimestamp(),
            'SenderId': senderId,
            "Destinataire": destId,
          });
          await chatCollection
              .doc(destId)
              .collection("Chat")
              .doc(sonTchat)
              .collection("Message")
              .doc(idMessage)
              .set({
            "idMessage": idMessage,
            "Sender": senderId,
            "Destinataire": destId,
            "Texte": text,
            "Image": image,
            "SendTime": FieldValue.serverTimestamp(),
          });

          return await chatCollection
              .doc(senderId)
              .collection("Chat")
              .doc(monTchat)
              .collection("Message")
              .doc(idMessage)
              .set({
            "idMessage": idMessage,
            "Sender": senderId,
            "Destinataire": destId,
            "Texte": text,
            "Image": image,
            "SendTime": FieldValue.serverTimestamp(),
          });
        } else {
          inbox.set({
            "MessagesNonLus": 1,
            "Texte": text,
            "Images": image,
            'SendTime': FieldValue.serverTimestamp(),
            'SenderId': senderId,
            "Destinataire": destId,
          });

          hebox.set({
            "MessagesNonLus": 1,
            "Texte": text,
            "Image": image,
            'SendTime': FieldValue.serverTimestamp(),
            'SenderId': senderId,
            "Destinataire": destId,
          });
          await chatCollection
              .doc(destId)
              .collection("Chat")
              .doc(sonTchat)
              .collection("Message")
              .doc(idMessage)
              .set({
            "idMessage": idMessage,
            "Sender": senderId,
            "Destinataire": destId,
            "Texte": text,
            "Image": image,
            "SendTime": FieldValue.serverTimestamp(),
          });

          return await chatCollection
              .doc(senderId)
              .collection("Chat")
              .doc(monTchat)
              .collection("Message")
              .doc(idMessage)
              .set({
            "idMessage": idMessage,
            "Sender": senderId,
            "Destinataire": destId,
            "Texte": text,
            "Image": image,
            "SendTime": FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  sendRealTime() async {
    String monTchat = "$senderId/$destId";
    String sonTchat = "$destId/$senderId";
    String inbox = "$senderId$destId";
    String hexbox = "$destId$senderId";
    chatRealtimeCollection.child(monTchat).get().then((value) async {
      if (value.exists) {
        await chatRealtimeCollection.child(monTchat).update({
          "MessagesNonLus": ServerValue.increment(1),
          "Texte": text,
          "Image": image,
          'SendTime': ServerValue.timestamp,
          'SenderId': senderId,
          "Destinataire": destId,
        });
        await chatRealtimeCollection.child(sonTchat).update({
          "MessagesNonLus": ServerValue.increment(1),
          "Texte": text,
          "Image": image,
          'SendTime': ServerValue.timestamp,
          'SenderId': senderId,
          "Destinataire": destId,
        });
        await messagesRealtimeCollection.child(inbox).child(idMessage!).set({
          "idMessage": idMessage,
          "Sender": senderId,
          "Destinataire": destId,
          "Texte": text,
          "Image": image,
          "SendTime": ServerValue.timestamp,
        });
        await messagesRealtimeCollection.child(hexbox).child(idMessage!).set({
          "idMessage": idMessage,
          "Sender": senderId,
          "Destinataire": destId,
          "Texte": text,
          "Image": image,
          "SendTime": ServerValue.timestamp,
        });
      } else {
        await chatRealtimeCollection.child(monTchat).set({
          "MessagesNonLus": 1,
          "Texte": text,
          "Image": image,
          'SendTime': ServerValue.timestamp,
          'SenderId': senderId,
          "Destinataire": destId,
        });
        await chatRealtimeCollection.child(sonTchat).set({
          "MessagesNonLus": 1,
          "Texte": text,
          "Image": image,
          'SendTime': ServerValue.timestamp,
          'SenderId': senderId,
          "Destinataire": destId,
        });
        await messagesRealtimeCollection.child(inbox).child(idMessage!).set({
          "idMessage": idMessage,
          "Sender": senderId,
          "Destinataire": destId,
          "Texte": text,
          "Image": image,
          "SendTime": ServerValue.timestamp,
        });
        await messagesRealtimeCollection.child(hexbox).child(idMessage!).set({
          "idMessage": idMessage,
          "Sender": senderId,
          "Destinataire": destId,
          "Texte": text,
          "Image": image,
          "SendTime": ServerValue.timestamp,
        });
      }
    });
  }

  factory Message.fromJson(map) => Message(
        senderId: map['Sender'],
        destId: map['Destinataire'],
        image: map['Image'],
        text: map['Texte'],
        sendDate: DateTime.fromMicrosecondsSinceEpoch(
            map["SendTime"]), //(map["SendTime"] as Timestamp).toDate(),
        idMessage: map['idMessage'] ?? "idMessage",
      );
  static Stream<List<Message>> inboxListrealTime(
          {required String senderId, required String destId}) =>
      messagesRealtimeCollection
          .child("$senderId$destId")
          .orderByChild("SendTime")
          .onValue
          .map((event) => event.snapshot.children
              .map((e) => Message.fromJson(e.value))
              .toList()
              .reversed
              .toList());

  static Stream<List<Message>> inboxList(
          {required String senderId, required String destId}) =>
      chatCollection
          .doc(senderId)
          .collection("Chat")
          .doc("$senderId$destId")
          .collection("Message")
          .orderBy("SendTime", descending: true)
          .snapshots()
          .map((doc) {
        return doc.docs.map((msg) {
          return Message.fromJson(msg.data());
        }).toList();
      });
}

class Discution {
  final String idDiscution;
  final String senderId;
  // final String idMessage;
  final String destId;
  final int messagesNonLus;
  final String? texte;
  final String? image;
  final DateTime sendTime;
  Discution({
    required this.idDiscution,
    required this.senderId,
    required this.sendTime,
    required this.destId,
    // required this.idMessage,
    required this.messagesNonLus,
    this.image,
    this.texte,
  });

  read() async {
    await chatCollection
        .doc(senderId)
        .collection('Chat')
        .doc("$senderId$destId")
        .update({"MessagesNonLus": 0});
    await chatCollection
        .doc(destId)
        .collection('Chat')
        .doc("$destId$senderId")
        .update({"MessagesNonLus": 0});
  }

  static Stream<List<Discution>> getdiscutionlist(String senderId) =>
      chatCollection
          .doc(senderId)
          .collection('Chat')
          .orderBy("SendTime", descending: true)
          .snapshots()
          .map((chat) {
        return chat.docs.map((msg) {
          print('id du document : ${msg.id} ');
          return Discution(
            idDiscution: msg.id,
            senderId: msg.data()['SenderId'],
            sendTime: (msg.data()['SendTime'] as Timestamp).toDate(),
            destId: msg.data()['Destinataire'],
            messagesNonLus: msg.data()['MessagesNonLus'],
            texte: msg.data()['Texte'],
            image: msg.data()['Image'],
          );
        }).toList();
      });

  factory Discution.froMap(msg, id) => Discution(
        idDiscution: id,
        senderId: msg['SenderId'],
        sendTime: DateTime.fromMicrosecondsSinceEpoch(msg['SendTime']),
        destId: msg['Destinataire'],
        messagesNonLus: msg['MessagesNonLus'],
        texte: msg['Texte'],
        image: msg['Image'],
      );
  static Stream<List<Discution>> getdiscutionlistRealTime(String discusion) {
    return chatRealtimeCollection
        .child(discusion)
        .orderByChild('SendTime')
        .onValue
        .map((event) {
      final discut = event.snapshot.children
          .toSet()
          .map((e) => Discution.froMap(e.value, e.key))
          .toList()
          .reversed
          .toList();
      return discut;
    });
  }
}
