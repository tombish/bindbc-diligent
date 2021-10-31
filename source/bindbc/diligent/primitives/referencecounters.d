/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Primitives/interface/ReferenceCounters.h
 *  The original licence follows this statement
 */

/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.primitives.referencecounters;

import bindbc.diligent.primitives.interfaceid;

alias ReferenceCounterValueType = long;

struct IObject;

struct IReferenceCountersMethods
{
    extern(C) @nogc nothrow {
        ReferenceCounterValueType function(IReferenceCounters*) AddStrongRef;
        ReferenceCounterValueType function(IReferenceCounters*) ReleaseStrongRef;
        ReferenceCounterValueType function(IReferenceCounters*) AddWeakRef;
        ReferenceCounterValueType function(IReferenceCounters*) ReleaseWeakRef;
        void function(IReferenceCounters*, IObject** ppObject) GetObject;
        ReferenceCounterValueType function(IReferenceCounters*) GetNumStrongRefs;
        ReferenceCounterValueType function(IReferenceCounters*) GetNumWeakRefs;
    }
}

struct IReferenceCountersVtbl { IReferenceCountersMethods ReferenceCounters; }

struct IReferenceCounters { IReferenceCountersVtbl* pVtbl; }

ReferenceCounterValueType refCountAddStrongRef(IReferenceCounters* i) {
return i.pVtbl.ReferenceCounters.AddStrongRef(cast(IReferenceCounters*)i);
}
ReferenceCounterValueType refCountReleaseStrongRef(IReferenceCounters* i) {
return i.pVtbl.ReferenceCounters.ReleaseStrongRef(cast(IReferenceCounters*)i);
}
ReferenceCounterValueType refCountAddWeakRef(IReferenceCounters* i) {
return i.pVtbl.ReferenceCounters.AddWeakRef(cast(IReferenceCounters*)i);
}
ReferenceCounterValueType refCountReleaseWeakRef(IReferenceCounters* i) {
return i.pVtbl.ReferenceCounters.ReleaseWeakRef(cast(IReferenceCounters*)i);
}
void refCountGetObject(IReferenceCounters* i, IObject** ppObject) {
    i.pVtbl.ReferenceCounters.GetObject(cast(IReferenceCounters*)i, ppObject);
}
ReferenceCounterValueType refCountGetNumStrongRefs(IReferenceCounters* i) {
return i.pVtbl.ReferenceCounters.GetNumStrongRefs(cast(IReferenceCounters*)i);
}
ReferenceCounterValueType refCountGetNumWeakRefs(IReferenceCounters* i) {
return i.pVtbl.ReferenceCounters.GetNumWeakRefs(cast(IReferenceCounters*)i);
}
