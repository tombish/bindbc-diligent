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

module bindbc.diligent.graphics.vulkan.commandqueuevk;

/// \file
/// Definition of the Diligent::ICommandQueueVk interface

import bindbc.diligent.graphics.commandqueue;

import erupted;

// {9FBF582F-3069-41B9-AC05-344D5AF5CE8C}
static const INTERFACE_ID IID_CommandQueueVk =
    INTERFACE_ID(0x9fbf582f, 0x3069, 0x41b9, [0xac, 0x5, 0x34, 0x4d, 0x5a, 0xf5, 0xce, 0x8c]);

/// Command queue interface
struct ICommandQueueVkMethods
{
    /// Submits a given command buffer to the command queue

    /// \return Fence value associated with the submitted command buffer
    ulong* SubmitCmdBuffer(ICommandQueueVk*, VkCommandBuffer cmdBuffer);

    /// Submits a given work batch to the internal Vulkan command queue

    /// \return Fence value associated with the submitted command buffer
    ulong* Submit(ICommandQueueVk*, const(VkSubmitInfo)* SubmitInfo);

    /// Presents the current swap chain image on the screen
    VkResult* Present(ICommandQueueVk*, const(VkPresentInfoKHR)* PresentInfo);

    /// Returns Vulkan command queue handle. May return VK_NULL_HANDLE if queue is anavailable
    ///
    /// \warning  Access to the VkQueue must be externally synchronized.
    ///           Don't use this method to submit commands directly, use SubmitCmdBuffer() or Submit(),
    ///           which are thread-safe.
    VkQueue* GetVkQueue(ICommandQueueVk*);

    /// Returns vulkan command queue family index
    uint* GetQueueFamilyIndex(ICommandQueueVk*);

    /// Signals the given fence
    void* EnqueueSignalFence(ICommandQueueVk*, VkFence vkFence);

    /// Signals the given timeline semaphore.
    ///
    /// \note  Requires NativeFence feature, see Diligent::DeviceFeatures.
    void* EnqueueSignal(ICommandQueueVk*, VkSemaphore vkTimelineSemaphore, ulong Value);
}

struct ICommandQueueVkVtbl { ICommandQueueVkMethods CommandQueueVk; }
struct ICommandQueueVk { ICommandQueueVkVtbl* pVtbl; }

ulong* SICommandQueueVk_SubmitCmdBuffer(ICommandQueueVk* cmdQueue, VkCommandBuffer cmdBuffer) {
    return cmdQueue.pVtbl.CommandQueueVk.SubmitCmdBuffer(cmdQueue, cmdBuffer);
}

ulong* SICommandQueueVk_Submit(ICommandQueueVk* cmdQueue, const(VkSubmitInfo)* submitInfo) {
    return cmdQueue.pVtbl.CommandQueueVk.Submit(cmdQueue, submitInfo);
}

VkResult* ICommandQueueVk_Present(ICommandQueueVk* cmdQueue, const(VkPresentInfoKHR)* presentInfo) {
    return cmdQueue.pVtbl.CommandQueueVk.Present(cmdQueue, presentInfo);
}

VkQueue* ICommandQueueVk_GetVkQueue(ICommandQueueVk* cmdQueue) {
    return cmdQueue.pVtbl.CommandQueueVk.GetVkQueue(cmdQueue);
}

uint* ICommandQueueVk_GetQueueFamilyIndex(ICommandQueueVk* cmdQueue) {
    return cmdQueue.pVtbl.CommandQueueVk.GetQueueFamilyIndex(cmdQueue);
}

void* ICommandQueueVk_EnqueueSignalFence(ICommandQueueVk* cmdQueue, VkFence vkFence) {
    return cmdQueue.pVtbl.CommandQueueVk.EnqueueSignalFence(cmdQueue, vkFence);
}

void* ICommandQueueVk_EnqueueSignal(ICommandQueueVk* cmdQueue, VkSemaphore vkTimelineSemaphore, ulong value) {
    return cmdQueue.pVtbl.CommandQueueVk.EnqueueSignal(cmdQueue, vkTimelineSemaphore, value);
}

