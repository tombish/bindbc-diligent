/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/primitives/interface/DataBlob.h
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

 module bindbc.diligent.primitives.datablob;

/// \file
/// Defines Diligent::IDataBlob interface

import bindbc.diligent.primitives.object;

// {F578FF0D-ABD2-4514-9D32-7CB454D4A73B}
static const INTERFACE_ID IID_DataBlob =
    INTERFACE_ID(0xf578ff0d, 0xabd2, 0x4514, [0x9d, 0x32, 0x7c, 0xb4, 0x54, 0xd4, 0xa7, 0x3b]);

struct IDataBlobMethods
{
    extern(C) @nogc nothrow {
        /// Sets the size of the internal data buffer
        void* Resize(IDataBlob*, size_t NewSize);

        /// Returns the size of the internal data buffer
        size_t* GetSize(IDataBlob*);

        /// Returns the pointer to the internal data buffer
        void** GetDataPtr(IDataBlob*);

        /// Returns const pointer to the internal data buffer
        const void** GetConstDataPtr(IDataBlob*);
    }
}

/// Base interface for a file stream
struct IDataBlobVtbl { IDataBlobMethods DataBlob; }
struct IDataBlob { IDataBlobVtbl* pVtbl; }

void* IDataBlob_Resize(IDataBlob* dataBlob, size_t newSize) {
    return dataBlob.pVtbl.DataBlob.Resize(dataBlob, newSize);
}

size_t* IDataBlob_GetSize(IDataBlob* dataBlob) {
    return dataBlob.pVtbl.DataBlob.GetSize(dataBlob);
}

void** IDataBlob_GetDataPtr(IDataBlob* dataBlob) {
    return dataBlob.pVtbl.DataBlob.GetDataPtr(dataBlob);
}

const void** IDataBlob_GetConstDataPtr(IDataBlob* dataBlob) {
    return dataBlob.pVtbl.DataBlob.GetConstDataPtr(dataBlob);
}