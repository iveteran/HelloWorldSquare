struct FSM_S
{
    int curState;                        //当前状态机状态
    int curFsmTableSize;                 //当前状态机查询表大小
    STATE_TABLE_T* curFsmTable;          //当前状态机查询表
    FSM_STACK_T stack[MAX_FSM_STACK_DEP];//状态机堆栈
    int curStackTop;                     //栈顶
    FSM_REGIST_T registFsm[MAX_FSM_NUM]; //注册状态机
    int registFsmNum;                    //注册状态机个数
};

void FSM_Init(FSM_T* pFsm);
void FSM_Regist(FSM_T* pFsm,STATE_TABLE_S* pStateTable,int FsmId,int curFsmTableSize);
void FSM_Begin(FSM_T* pFsm,int FsmId);
void FSM_MoveState(FSM_T* pFsm,int state);
void FSM_EventHandle(FSM_T* pFsm,int event);
void FSM_Push(FSM_T* pFsm);void FSM_Pop(FSM_T* pFsm);


void FSM_Regist(FSM_T* pFsm,STATE_TABLE_S* pStateTable,int FsmId, int curFsmTableSize)
{
    pFsm->registFsm[pFsm->registFsmNum].fsmId = FsmId;
    pFsm->registFsm[pFsm->registFsmNum].FsmTable = pStateTable;
    pFsm->registFsm[pFsm->registFsmNum].fsmTableSize = curFsmTableSize;

    pFsm->registFsmNum++;
    return;
}

void FSM_Begin(FSM_T* pFsm,int FsmId)
{
    for(int i=0;i<pFsm->registFsmNum;i++)
    {
        if(FsmId == pFsm->registFsm[i].fsmId)
        {
            pFsm->curFsmTable = pFsm->registFsm[i].FsmTable;
            pFsm->curFsmTableSize = pFsm->registFsm[i].fsmTableSize;
            break;
        }
    }
    return;
}

void FSM_Push(FSM_T* pFsm)
{
        if(pFsm->curStackTop < MAX_FSM_STACK_DEP)
                {
                            pFsm->curStackTop++;
                                    pFsm->stack[pFsm->curStackTop].state     = pFsm->curState;
                                            pFsm->stack[pFsm->curStackTop].pFsmTable = pFsm->curFsmTable;
                                                    pFsm->stack[pFsm->curStackTop].fsmTableSize = pFsm->curFsmTableSize;
                                                        }

            return;
}

void FSM_Pop(FSM_T* pFsm)
{
    if(pFsm->curStackTop > -1)
    {
        pFsm->curState   = pFsm->stack[pFsm->curStackTop].state;
        pFsm->curFsmTable = pFsm->stack[pFsm->curStackTop].pFsmTable;
        pFsm->curFsmTableSize = pFsm->stack[pFsm->curStackTop].fsmTableSize;
        pFsm->curStackTop--;
    }

    return;
}

/*L1 状态机定义*/
ACT_TABLE_T L1state1ActTable[] = {
    {L1_EVENT1,L1state1_Event1Fun},
    {L1_EVENT3,L1state1_Event3Fun},
};
ACT_TABLE_T L1state2ActTable[] = {
    {L1_EVENT2,L1state2_Event2Fun},
    {L1_L2_EVENT1,L1state2_L1L2EventFun},
};
STATE_TABLE_T L1FsmTable[] = {
    {L1_STATE1,sizeof(L1state1ActTable)/sizeof(ACT_TABLE_T),L1state1ActTable},
    {L1_STATE2,sizeof(L1state2ActTable)/sizeof(ACT_TABLE_T),L1state2ActTable},
};
/*L2 状态机定义*/
ACT_TABLE_T L2state1ActTable[] = {
    {L2_EVENT1,L2state1_L2Event1Fun},
};
ACT_TABLE_T L2state2ActTable[] = {
    {L1_L2_EVENT2,L2state2_L1L2EvenFun},
};
STATE_TABLE_T L2FsmTable[] = {
    {L2_STATE1,sizeof(L2state1ActTable)/sizeof(ACT_TABLE_T),L2state1ActTable},
    {L2_STATE2,sizeof(L2state2ActTable)/sizeof(ACT_TABLE_T),L2state2ActTable},
};

void L1state2_L1L2EventFun(void* pFsm)
{
    FSM_Push((FSM_T*)pFsm);
    FSM_Begin((FSM_T*)pFsm,FSM_L2);
    FSM_MoveState((FSM_T*)pFsm,L2_STATE1);

    return;
}
void L2state2_L1L2EvenFun(void* pFsm)
{
    FSM_Pop((FSM_T*)pFsm);

    return;
}


int main(int argc, _TCHAR* argv[])
{
    FSM_T pFsm;

    FSM_Init(&pFsm);
    /*状态机注册*/
    FSM_Regist(&pFsm,L1FsmTable,FSM_L1,sizeof(L1FsmTable)/sizeof(STATE_TABLE_T));
    FSM_Regist(&pFsm,L2FsmTable,FSM_L2,sizeof(L2FsmTable)/sizeof(STATE_TABLE_T));
    /*开始L1状态机*/
    FSM_Begin(&pFsm,FSM_L1);
    FSM_MoveState(&pFsm,L1_STATE1);
    FSM_EventHandle(&pFsm,L1_EVENT1);
    /*push 状态机*/
    FSM_EventHandle(&pFsm,L1_L2_EVENT1);
    /*L2状态机处理*/
    FSM_EventHandle(&pFsm,L2_EVENT1);
    /*pop 状态机*/
    FSM_EventHandle(&pFsm,L1_L2_EVENT2);
    /*L1状态机处理*/
    FSM_EventHandle(&pFsm,L1_EVENT2);
    return 0;
}
