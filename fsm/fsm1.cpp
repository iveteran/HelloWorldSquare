/*状态表注册*/
void FSM_Regist(FSM_T* pFsm,STATE_TABLE_S* pStateTable)
{
    pFsm->FsmTable =  pStateTable;
    return;
}
/*状态迁移*/
void FSM_MoveState(FSM_T* pFsm,int state)
{
    pFsm->curState = state;
    return;
}
/*事件处理*/
void FSM_EventHandle(FSM_T* pFsm,int event)
{
    ACT_TABLE_T* pActTable = NULL;
    ActFun eventActFun = NULL;
    /*获取当前状态动作表*/
    pActTable = FSM_getActTable(pFsm);
    /*获取当前动作函数*/
    for(int i=0;i<MAX_ACT_NUM;i++)
    {
        if(event == pActTable[i].event)
        {
            eventActFun = pActTable[i].eventActFun;
            break;
        }
    }
    /*动作执行*/
    if(eventActFun)
    {
        eventActFun(pFsm);
    }
}

/*状态1的动作表*/
ACT_TABLE_T state1ActTable[] = {
    {EVENT1,state1Event1Fun},
    {EVENT3,state1Event3Fun},
};
/*状态2的动作表*/
ACT_TABLE_T state2ActTable[] = {
    {EVENT2,state2Event2Fun},
};
/*状态表*/
STATE_TABLE_T FsmTable[] = {
    {STATE1,state1ActTable},
    {STATE2,state2ActTable},
};
/*客户端提供的状态处理函数*/
void state1Event1Fun(void* pFsm)
{
    FSM_MoveState((FSM_T*)pFsm,STATE2);
}
void state1Event3Fun(void* pFsm)
{
    FSM_MoveState((FSM_T*)pFsm,STATE3);
}
void state2Event2Fun(void* pFsm)
{
    FSM_MoveState((FSM_T*)pFsm,STATE3);
}

int main(int argc, _TCHAR* argv[])
{
    FSM_T fsm;
    /*状态表注册*/
    FSM_Regist(&fsm,FsmTable);
    FSM_MoveState(&fsm,STATE1);
    FSM_EventHandle(&fsm,EVENT1);
    FSM_EventHandle(&fsm,EVENT2);
    return 0;
}
