#ifndef LIB_CLIENT_H_
#define LIB_CLIENT_H_

#include "macro.h"
#include <arpa/inet.h>
#include <netinet/in.h>
#include <ev.h>
#include "buffer_yi.h"
#include <functional>
#include <string>

#include <openssl/ssl.h>

typedef std::shared_ptr<yijian::buffer> Buffer_SP;
typedef std::function<void(Buffer_SP)> Read_CB;
//typedef void (*IsConnectSuccess)();
typedef std::function<void(const int error_no, const std::string && error_msg)> Client_CB;

// main thread call, read_cb subthread callback
void create_client(std::string certpath, Buffer_SP ping,
                   Read_CB && read_cb,
                   Client_CB callback);
// main thread call
void client_send(Buffer_SP sp_buffer, uint16_t * sessionid);
// main thread call
void clear_client();
// main thread call
// set net is connect
void client_setNet_isConnect(bool isConnect);

#endif
