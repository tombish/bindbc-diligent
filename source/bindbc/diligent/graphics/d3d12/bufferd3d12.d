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

module bindbc.diligent.graphics.d3d12.bufferd3d12;

/// \file
/// Definition of the Diligent::IBufferD3D12 interface

import bindbc.diligent.graphics.buffer;
import bindbc.diligent.graphics.devicecontext;

// {3E9B15ED-A289-48DC-8214-C6E3E6177378}
static const INTERFACE_ID IID_BufferD3D12 =
    INTERFACE_ID(0x3e9b15ed, 0xa289, 0x48dc, [0x82, 0x14, 0xc6, 0xe3, 0xe6, 0x17, 0x73, 0x78]);

/// Exposes Direct3D12-specific functionality of a buffer object.
struct IBufferD3D12Methods
{
    extern(C) @nogc nothrow {
        /// Returns a pointer to the ID3D12Resource interface of the internal Direct3D12 object.

        /// The method does *NOT* increment the reference counter of the returned object,
        /// so Release() must not be called.
        /// \param [in] DataStartByteOffset - Offset from the beginning of the buffer
        ///                            to the start of the data. This parameter
        ///                            is required for dynamic buffers, which are
        ///                            suballocated in a dynamic upload heap
        /// \param [in] pContext - Device context within which address of the buffer is requested.
        ID3D12Resource** GetD3D12Buffer(IBufferD3D12*, ulong* DataStartByteOffset, IDeviceContext* pContext);

        /// Sets the buffer usage state

        /// \param [in] state - D3D12 resource state to be set for this buffer
        void* SetD3D12ResourceState(IBufferD3D12*, D3D12_RESOURCE_STATES state);

        /// Returns current D3D12 buffer state.
        /// If the state is unknown to the engine (Diligent::RESOURCE_STATE_UNKNOWN),
        /// returns D3D12_RESOURCE_STATE_COMMON (0).
        ID3D12Resource**  GetD3D12ResourceState(IBufferD3D12*);
    }
}

struct IBufferD3D12Vtbl { IBufferD3D12Methods BufferD3D12; }
struct IBufferD3D12 { IBufferD3D12Vtbl* pVtbl; }

ID3D12Resource** IBufferD3D12_GetD3D12Buffer(IBufferD3D12* buffer, ulong* DataStartByteOffset, IDeviceContext* pContext) {
    return buffer.pVtbl.BufferD3D12.GetD3D12Buffer(buffer, DataStartByteOffset, pContext);
}

void* IBufferD3D12_SetD3D12ResourceState(IBufferD3D12* buffer, D3D12_RESOURCE_STATES state) {
    return buffer.pVtbl.BufferD3D12.SetD3D12ResourceState(buffer, state);
}

ID3D12Resource** IBufferD3D12_GetD3D12ResourceState(IBufferD3D12* buffer) {
    return buffer.pVtbl.BufferD3D12.GetD3D12ResourceState(buffer);
}