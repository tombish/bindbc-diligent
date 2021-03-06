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

module bindbc.diligent.graphics.vulkan.bufferviewvk;

/// \file
/// Definition of the Diligent::IBufferViewVk interface

import bindbc.diligent.graphics.bufferview;

import erupted;

// {CB67024A-1E23-4202-A49A-07B6BCEABC06}
static const INTERFACE_ID IID_BufferViewVk =
    INTERFACE_ID(0xcb67024a, 0x1e23, 0x4202, [0xa4, 0x9a, 0x7, 0xb6, 0xbc, 0xea, 0xbc, 0x6]);

/// Exposes Vulkan-specific functionality of a buffer view object.
struct IBufferViewVkMethods
{
    /// Returns a Vulkan handle of the internal buffer view object.
    VkBufferView* GetVkBufferView(IBufferViewVk*);
}

struct IBufferViewVkVtbl { IBufferViewVkMethods BufferViewVk; }
struct IBufferViewVk { IBufferViewVkVtbl* pVtbl; }

VkBufferView* IBufferViewVk_GetVkBufferView(IBufferViewVk* bufferView) {
    return bufferView.pVtbl.BufferViewVk.GetVkBufferView(bufferView);
}
