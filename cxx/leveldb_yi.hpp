//
//  leveldb_yi.hpp
//  heibaiyu
//
//  Created by jiwei.wang on 2/10/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#ifndef leveldb_yi_hpp
#define leveldb_yi_hpp

#include <stdio.h>
#include <leveldb/db.h>
#include "chat_message.pb.h"

class leveldb_yi {
public:
  leveldb_yi(std::string & dbpath);
  ~leveldb_yi();
  
  /*
   * user
   * */
  void putUser(chat::User & user);
  chat::User getUser(const std::string & id);
  chat::User getUser(const std::string & countrycode,
               const std::string & phoneno);
  chat::User getCurrentUser();
  
  /*
   * add friend info
   */
  void putAddfriendInfo(chat::AddFriendInfo & info);
  chat::AddFriendInfo getAddfriendInfo();
  
  
  
  
private:
  /*
   * common leveldb put get
   *
   * */
  void put(const leveldb::Slice & key,
      const leveldb::Slice & value);
  void put(leveldb::WriteBatch & batch);
  std::string get(const leveldb::Slice & key);
  /*
   * current
   * */
  // current user key = current_user
  std::string getCurrentUserid();
  void setCurrentUserid(const std::string & userid);


  /*
   * user key
   * */
  // u_$userid
  std::string userKey(const std::string & userid);
  // p_$code_$phoneno
  std::string userPhoneKey(const std::string & countrycode,
      const std::string phoneno);
  // addfriendinfo_kvdb_$currentuserid
  std::string addFriendInfoKey();
  /*
   * message key
   * */
  // n_$tonodeid
  std::string nodeKey(const std::string & tonodeid);
  // m_$tonodeid_$incrementid
  std::string msgKey(const std::string & tonodeid,
      const std::string & incrementid);
  std::string msgKey(const std::string & tonodeid,
      const int32_t incrementid);
  // t_&userid
  std::string talklistKey();
  /*
   * error key
   * */
  // e_userid_$nth
  std::string errorKey(const std::string & userid,
      const int32_t nth);
  /*
   * un used
  // signup_kvdb
  std::string signupKey();
  // login_kvdb
  std::string loginKey();
  // logout_kvdb
  std::string logoutKey();
  // connect_kvdb
  std::string connectKey();
  // disconnect_kvdb
  std::string disconnectKey();
  // loginnoti_kvdb
  std::string loginNotiKey();
  // addfriendnoti_kvdb
  std::string addFriendNotiKey();
  // addfriendauthorizenoti_kvdb
  std::string addFriendAuthorizeNotiKey();
   * */
  
private:
  leveldb::DB * db_;
};

#endif /* leveldb_yi_hpp */