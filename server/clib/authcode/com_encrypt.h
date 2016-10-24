/*
 * com_encrypt.h
 *
 *  Created on: 2013��7��24��
 *      Author: Administrator
 */

#ifndef COM_ENCRYPT_H_
#define COM_ENCRYPT_H_

#ifdef __cplusplus
extern "C"
{
#endif
#include <lua.h>
#include <lauxlib.h>
	/**
	* @param1 string source �����ԭ�Ļ�������
	* @param2 string $is_encode ����(true is encode | false is DECODE), Ĭ��Ϊ true
	* @param3 string $key ��Կ
	* @param4 int $expiry ������Ч��, ����ʱ����Ч�� ��λ �룬0 Ϊ������Ч
	* @return �ַ���,���ص�lua,���ܵ�ԭ�Ļ��� ���ܵ�����
	*/
int _com_encrypt(lua_State *L);
int _base64decode(lua_State *L);
int _base64encode(lua_State *L);

#ifdef __cplusplus
};
#endif

#endif /* COM_ENCRYPT_H_ */
