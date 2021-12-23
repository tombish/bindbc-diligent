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

module bindbc.diligent.graphics.vulkan.pipelinestatevk;

/// \file
/// Definition of the Diligent::IPipeplineStateVk interface

import bindbc.diligent.graphics.pipelinestate;
import bindbc.diligent.graphics.vulkan.renderpassvk;

import erupted;

// {2FEA0868-0932-412A-9F0A-7CEA7E61B5E0}
static const INTERFACE_ID IID_PipelineStateVk =
    INTERFACE_ID(0x2fea0868, 0x932, 0x412a, [0x9f, 0xa, 0x7c, 0xea, 0x7e, 0x61, 0xb5, 0xe0]);

/// Exposes Vulkan-specific functionality of a pipeline state object.
struct IPipelineStateVkMethods
{
    /// Returns a pointer to the internal render pass object.
    IRenderPassVk** GetRenderPass(IPipelineStateVk*);

    /// Returns a Vulkan handle of the internal pipeline state object.
    VkPipeline* GetVkPipeline(IPipelineStateVk*);
}

struct IPipelineStateVkVtbl { IPipelineStateVkMethods PipelineStateVk; }
struct IPipelineStateVk { IPipelineStateVkVtbl* pVtbl; }

IRenderPassVk** IPipelineStateVk_GetRenderPass(IPipelineStateVk* pipelineState) {
    return pipelineState.pVtbl.PipelineStateVk.GetRenderPass(pipelineState);
}

VkPipeline* IPipelineStateVk_GetVkPipeline(IPipelineStateVk* pipelineState) {
    return pipelineState.pVtbl.PipelineStateVk.GetVkPipeline(pipelineState);
}