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

module bindbc.diligent.graphics.d3d12.devicecontextd3d12;

/// \file
/// Definition of the Diligent::IDeviceContextD3D12 interface

import bindbc.diligent.graphics.devicecontext;
import bindbc.diligent.graphics.d3d12.commandqueued3d12;

// {DDE9E3AB-5109-4026-92B7-F5E7EC83E21E}
static const INTERFACE_ID IID_DeviceContextD3D12 =
    INTERFACE_ID(0xdde9e3ab, 0x5109, 0x4026, [0x92, 0xb7, 0xf5, 0xe7, 0xec, 0x83, 0xe2, 0x1e]);

/// Exposes Direct3D12-specific functionality of a device context.
struct IDeviceContextD3D12Methods
{
    extern(C) @nogc nothrow {
        /// Transitions internal D3D12 texture object to a specified state

        /// \param [in] pTexture - texture to transition
        /// \param [in] State - D3D12 resource state this texture to transition to
        void* TransitionTextureState(IDeviceContextD3D12*,
                                                    ITexture*             pTexture,
                                                    D3D12_RESOURCE_STATES State);

        /// Transitions internal D3D12 buffer object to a specified state

        /// \param [in] pBuffer - Buffer to transition
        /// \param [in] State - D3D12 resource state this buffer to transition to
        void* TransitionBufferState(IDeviceContextD3D12*,
                                                   IBuffer*              pBuffer,
                                                   D3D12_RESOURCE_STATES State);

        /// Returns a pointer to Direct3D12 graphics command list that is currently being recorded

        /// \return - a pointer to the current command list
        ///
        /// \remarks  Any command on the device context may potentially submit the command list for
        ///           execution into the command queue and make it invalid. An application should
        ///           never cache the pointer and should instead request the command list every time it
        ///           needs it.
        ///
        ///           The engine manages the lifetimes of all command buffers, so an application must
        ///           not call AddRef/Release methods on the returned interface.
        ///
        ///           Diligent Engine internally keeps track of all resource state changes (vertex and index
        ///           buffers, pipeline states, render targets, etc.). If an application changes any of these
        ///           states in the command list, it must invalidate the engine's internal state tracking by
        ///           calling IDeviceContext::InvalidateState() and then manually restore all required states via
        ///           appropriate Diligent API calls.
        ID3D12GraphicsCommandList** GetD3D12CommandList(IDeviceContextD3D12*);
    }
}

struct IDeviceContextD3D12Vtbl { IDeviceContextD3D12Methods DeviceContextD3D12; }
struct IDeviceContextD3D12 { IDeviceContextD3D12Vtbl* pVtbl; }

void* IDeviceContextD3D12_TransitionTextureState(IDeviceContextD3D12* deviceContext,
                                                ITexture*             pTexture,
                                                D3D12_RESOURCE_STATES state) {
    return deviceContext.pVtbl.DeviceContextD3D12.TransitionTextureState(deviceContext, pTexture, state);
}

void* IDeviceContextD3D12_TransitionBufferState(IDeviceContextD3D12* deviceContext,
                                               IBuffer*              pBuffer,
                                               D3D12_RESOURCE_STATES state) {
    return deviceContext.pVtbl.DeviceContextD3D12.TransitionBufferState(deviceContext, pBuffer, state);
}

ID3D12GraphicsCommandList** IDeviceContextD3D12_GetD3D12CommandList(IDeviceContextD3D12* deviceContext) {
    return deviceContext.pVtbl.DeviceContextD3D12.GetD3D12CommandList(deviceContext); 
}