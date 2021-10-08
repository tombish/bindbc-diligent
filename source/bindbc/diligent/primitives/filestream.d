/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Primitives/interface/FileStream.h
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

/// \file
/// Defines Diligent::IFileStream interface

import bindbc.diligent.primitives.object;
import bindbc.diligent.primitives.datablob;

/// IFileStream interface unique identifier
// {E67F386C-6A5A-4A24-A0CE-C66435465D41}
static const struct INTERFACE_ID IID_FileStream =
    INTERFACE_ID(0xe67f386c, 0x6a5a, 0x4a24, [0xa0, 0xce, 0xc6, 0x64, 0x35, 0x46, 0x5d, 0x41]);

#define DILIGENT_INTERFACE_NAME IFileStream
#include "DefineInterfaceHelperMacros.h"

#define IFileStreamInclusiveMethods \
    IObjectInclusiveMethods;        \
    IFileStreamMethods FileStream

#    define DILIGENT_BEGIN_INTERFACE(Iface, Base) \
        typedef struct Iface                      \
        {                                         \
            struct Iface##Vtbl* pVtbl;            \
        } Iface;                                  \
        struct Iface##Methods

struct IFileStream { struct IFileStreamVtbl* pVtbl; }

struct IFileStreamMethods
{
    /// Reads data from the stream
    bool Read(IFileStream*, void* Data, size_t BufferSize);

    void ReadBlob(IFileStream*, IDataBlob* pData);

    /// Writes data to the stream
    bool Write(IFileStream*, const void* Data, size_t Size);

    size_t* GetSize(IFileStream*);

    bool IsValid(IFileStream*);
}

/// Base interface for a file stream
DILIGENT_BEGIN_INTERFACE(IFileStream, IObject)
{
    
};
DILIGENT_END_INTERFACE

#include "UndefInterfaceHelperMacros.h"

#    define IFileStream_Read(This, ...)     CALL_IFACE_METHOD(FileStream, Read,     This, __VA_ARGS__)
#    define IFileStream_ReadBlob(This, ...) CALL_IFACE_METHOD(FileStream, ReadBlob, This, __VA_ARGS__)
#    define IFileStream_Write(This, ...)    CALL_IFACE_METHOD(FileStream, Write,    This, __VA_ARGS__)
#    define IFileStream_GetSize(This)       CALL_IFACE_METHOD(FileStream, GetSize,  This)
#    define IFileStream_IsValid(This)       CALL_IFACE_METHOD(FileStream, IsValid,  This)
