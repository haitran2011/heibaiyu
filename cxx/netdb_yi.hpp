//
//  netdb_yi.hpp
//  heibaiyu
//
//  Created by jiwei.wang on 2/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#ifndef netdb_yi_hpp
#define netdb_yi_hpp

#include <stdio.h>
#include "macro.h"
#include <leveldb/db.h>
#include <google/chat_message.pb.h>
#include "net_yi.h"
#include "leveldb_yi.hpp"

class netdb_yi {
  
public:
  
  // err_no == 0 success
  typedef std::function<void(const int err_no, const std::string & err_msg)>
    CB_Func;
  netdb_yi(const std::string & certpath, const std::string & dbpath, const std::string & phoneModel, const std::string & phoneUDID, const std::string & osVersion, const std::string & appVersion);
  ~netdb_yi();
  void openNet(Client_CB client_callback);
  void netIsReachable(bool isreachable);
  void closeNet();
  
  /*
   * user
   */
  void registCheck(const std::string & phoneno, const std::string & countrycode, CB_Func && callback);
  void regist(const std::string & phoneno, const std::string & countrycode, const std::string & passwordj, const std::string & verifycode, CB_Func && callback);
  void login(const std::string & phoneno, const std::string & countrycode, const std::string & password, CB_Func && callback);
  void connect(const std::string & userid, CB_Func && callback);
  void disconnect(CB_Func && callback);
  void logout(CB_Func && callback);
  
  void userSetRealname(const std::string & realname, CB_Func && callback);
  void userSetNickname(const std::string & nickname, CB_Func && callback);
  void userSetIcon(const std::string & icon, CB_Func && callback);
  void userSetIsmale(const bool isMale, CB_Func && callback);
  void userSetBirthday(const int32_t birthdayTimestamp, CB_Func && callback);//seconds
  void userSetDescription(const std::string & description, CB_Func && callback);
  
  void addFriend(const std::string & friendid, CB_Func && callback);
  void addFriendAuthorize(const std::string & friendid, CB_Func && callback);
  void getAddfriendInfo(CB_Func && callback);
  
  void getUser(const std::string & userid, CB_Func && callback);
  void getUser(const std::string & phone, const std::string & countrycode, CB_Func && callback);
  
private:
  std::atomic_bool isOpenNet_;
  netyi * netyi_;
  leveldb_yi * dbyi_;
  Client_CB client_callback_;
  
  std::string model_;
  std::string udid_;
  std::string os_version_;
  std::string app_version_;
  std::string certpath_;
};

#endif /* netdb_yi_hpp */
