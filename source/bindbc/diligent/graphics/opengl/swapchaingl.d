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

module bindbc.diligent.graphics.opengl.swapchaingl;

/// \file
/// Definition of the Diligent::ISwapChainGL interface

import bindbc.diligent.graphics.swapchain;

import bindbc.opengl;

// {F457BD7C-E725-4D3E-8607-A1F9BAE329EB}
static const INTERFACE_ID IID_SwapChainGL =
    INTERFACE_ID(0xf457bd7c, 0xe725, 0x4d3e, [0x86, 0x7, 0xa1, 0xf9, 0xba, 0xe3, 0x29, 0xeb]);

/// Exposes OpenGL-specific functionality of a swap chain.
struct ISwapChainGLMethods
{
    /// Returns the default framebuffer handle
    GLuint* GetDefaultFBO(ISwapChainGL*);
}

struct ISwapChainGLVtbl { ISwapChainGLMethods SwapChainGL; }
struct ISwapChainGL { ISwapChainGLVtbl* pVtbl; }

GLuint* ISwapChainGL_GetDefaultFBO(ISwapChainGL* swapchain) {
    return swapchain.pVtbl.SwapChainGL.GetDefaultFBO(swapchain);
}
