/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Primitives/interface/InterfaceID.h
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

module bindbc.diligent.primitives.interfaceid;

/// Unique interface identifier
struct INTERFACE_ID
{
    uint data1;
    ushort data2;
    ushort data3;
    ubyte[8] data4;

    bool opEquals()(auto ref const INTERFACE_ID s) const {
         return data1 == s.data1 &&
            data2 == s.data2 &&
            data3 == s.data3 &&
            memcmp(data4, s.data4, sizeof(data4)) == 0;
    }

}

/// Unknown interface
static const INTERFACE_ID IID_Unknown = INTERFACE_ID(0, 0, 0, [0, 0, 0, 0, 0, 0, 0, 0]);