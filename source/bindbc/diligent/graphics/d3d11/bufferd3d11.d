/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
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

module bindbc.diligent.graphics.d3d11.bufferd3d11;

/// \file
/// Definition of the Diligent::IBufferD3D11 interface

import bindbc.diligent.graphics.buffer;

// {4A696D2E-44BB-4C4B-9DE2-3AF7C94DCFC0}
static const INTERFACE_ID IID_BufferD3D11 =
    INTERFACE_ID(0x4a696d2e, 0x44bb, 0x4c4b, [0x9d, 0xe2, 0x3a, 0xf7, 0xc9, 0x4d, 0xcf, 0xc0]);

/// Exposes Direct3D11-specific functionality of a buffer object.
struct IBufferD3D11Methods
{
    /// Returns a pointer to the ID3D11Buffer interface of the internal Direct3D11 object.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    ID3D11Buffer** GetD3D11Buffer(IBufferD3D11*);
}

struct IBufferD3D11Vtbl { IBufferD3D11Methods BufferD3D11; }
struct IBufferD3D11 { IBufferD3D11Vtbl* pVtbl; }

// #    define IBufferD3D11_GetD3D11Buffer(This) CALL_IFACE_METHOD(BufferD3D11, GetD3D11Buffer, This)

ID3D11Buffer** IBufferD3D11_GetD3D11Buffer(IBufferD3D11* buffer) {
    buffer.pVtbl.BufferD3D11.GetD3D11Buffer(buffer);
}