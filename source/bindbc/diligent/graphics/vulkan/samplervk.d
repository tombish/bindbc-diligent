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

module bindbc.diligent.graphics.vulkan.samplervk;

/// \file
/// Definition of the Diligent::ISamplerVk interface

import bindbc.diligent.graphics.sampler;

// {87C21E88-8A9F-4AD2-9A1E-D5EC140415EA}
static const INTERFACE_ID IID_SamplerVk =
    INTERFACE_ID(0x87c21e88, 0x8a9f, 0x4ad2, [0x9a, 0x1e, 0xd5, 0xec, 0x14, 0x4, 0x15, 0xea]);

/// Exposes Vulkan-specific functionality of a sampler object.
struct ISamplerVkMethods
{
    /// Returns a Vulkan handle of the internal sampler object.
    VkSampler* GetVkSampler(ISamplerVk*);
}

struct ISamplerVkVtbl { ISamplerVkMethods SamplerVk; }
struct ISamplerVk { ISamplerVkVtbl* pVtbl; }

VkSampler* ISamplerVk_GetVkSampler(ISamplerVk* sampler) {
    return sampler.pVtbl.SamplerVk.GetVkSampler(sampler);
}