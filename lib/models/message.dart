import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Message {
  String? id;
  String? userId;
  String? message;
  DateTime? messageTimestamp;

  Message({
    @required id,
    @required userId,
    @required message,
    @required messageTimestamp,
  });

  //list of messages
  List<Message> messages = [];

  //get all messages
  List<Message> getAllMessages() {
    return messages;
  }

  //create a new message
  String newMessage(String userId, String message) {
    //check if parameters are not empty
    if (userId.isNotEmpty && message.isNotEmpty) {
      // message id
      final messageId = Uuid().v4();
      // timestamp for message
      final messageTimestamp = DateFormat(
        'EEE, MMM d, y hh:mm aaa',
      ).format(DateTime.now());
      // new message constructor
      final newMessage = Message(
        id: messageId,
        userId: userId,
        message: message,
        messageTimestamp: messageTimestamp,
      );
      // add new message
      messages.add(newMessage);
      //check if new message has been added
      if (messages.contains(newMessage)) {
        return 'message added successfully';
      } else {
        return 'failed to add message';
      }
    } else {
      return 'no empty values';
    }
  }

  //update a message
  String updateMessage(int index, [String? message]) {
    //check if message exists
    if (messages.contains(messages[index])) {
      // update individual values of message
      messages[index].message = message ?? messages[index].message;
      //check if message has been updated
      if(messages[index].message == message){
        return 'message updated successfully';
      }else{
        return 'failed to update message';
      }
    } else {
      return 'message does not exist';
    }
  }

  //delete a message
  String deleteMessage(int index){
    //check if message exists
    if(messages.contains(messages[index])){
      //delete message
      messages.remove(messages[index]);
      //check if message has been deleted
      if(messages.contains(messages[index])){
        return 'failed to delete message';
      }else{
        return 'message was deleted successfully';
      }
    }else{
      return 'message does not exist';
    }
  }

  //delete all messages
  String deleteAllMessages(){
    //check if messages are there
    if(messages.isNotEmpty){
      //remove all messages
      messages.clear();
      //check if messages have been deleted
      if(messages.isNotEmpty){
        return 'failed to delete all messages';
      }else{
        return 'all messages deleted successfully';
      }
    }else{
      return 'no messages';
    }
  }
}
