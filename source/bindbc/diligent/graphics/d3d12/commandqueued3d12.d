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

module bindbc.diligent.graphics.d3d12.commandqueued3d12;

/// \file
/// Definition of the Diligent::ICommandQueueD3D12 interface

import bindbc.diligent.graphics.commandqueue;

// {D89693CE-F3F4-44B5-B7EF-24115AAD085E}
static const INTERFACE_ID IID_CommandQueueD3D12 =
    INTERFACE_ID(0xd89693ce, 0xf3f4, 0x44b5, [0xb7, 0xef, 0x24, 0x11, 0x5a, 0xad, 0x8, 0x5e]);

/// Command queue interface
struct ICommandQueueD3D12Methods
{
    extern(C) @nogc nothrow {
        /// Submits command lists for execution.

        /// \param[in]  NumCommandLists - The number of command lists to submit.
        /// \param[in]  ppCommandLists  - A pointer to the array of NumCommandLists command
        ///                               lists to submit.
        ///
        /// \return Fence value associated with the executed command lists.
        ulong* Submit(ICommandQueueD3D12*, uint NumCommandLists, const ID3D12CommandList** ppCommandLists);

        /// Returns D3D12 command queue. May return null if queue is anavailable
        ID3D12CommandQueue** GetD3D12CommandQueue(ICommandQueueD3D12*);

        /// Signals the given fence
        void* EnqueueSignal(ICommandQueueD3D12*, ID3D12Fence* pFence, ulong Value);

        /// Instructs the GPU to wait until the fence reaches the specified value
        void* WaitFence(ICommandQueueD3D12*, ID3D12Fence* pFence, ulong Value);

        /// Returns the Direct3D12 command queue description
        const D3D12_COMMAND_QUEUE_DESC** GetD3D12CommandQueueDesc(ICommandQueueD3D12*);
    }
}

struct ICommandQueueD3D12Vtbl { ICommandQueueD3D12Methods CommandQueueD3D12; }
struct ICommandQueueD3D12 { ICommandQueueD3D12Vtbl* pVtbl; }

ulong* ICommandQueueD3D12_Submit(ICommandQueueD3D12* cmdQueue, uint NumCommandLists, const ID3D12CommandList** ppCommandLists) {
    return cmdQueue.pVtbl.CommandQueueD3D12.Submit(cmdQueue, NumCommandLists, ppCommandLists);
}

ID3D12CommandQueue** ICommandQueueD3D12_GetD3D12CommandQueue(ICommandQueueD3D12* cmdQueue) {
    return cmdQueue.pVtbl.CommandQueueD3D12.GetD3D12CommandQueue(cmdQueue);
}

void* ICommandQueueD3D12_EnqueueSignal(ICommandQueueD3D12* cmdQueue, ID3D12Fence* pFence, ulong Value) {
    return cmdQueue.pVtbl.CommandQueueD3D12.EnqueueSignal(cmdQueue, pFence, Value);
}

void* ICommandQueueD3D12_WaitFence(ICommandQueueD3D12* cmdQueue, ID3D12Fence* pFence, ulong Value) {
    return cmdQueue.pVtbl.CommandQueueD3D12.WaitFence(cmdQueue, pFence, Value);
}

const D3D12_COMMAND_QUEUE_DESC** ICommandQueueD3D12_GetD3D12CommandQueueDesc(ICommandQueueD3D12* cmdQueue) {
    return cmdQueue.pVtbl.CommandQueueD3D12.GetD3D12CommandQueueDesc(cmdQueue);
}