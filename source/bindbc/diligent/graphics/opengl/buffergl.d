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

module bindbc.diligent.graphics.opengl.buffergl;

/// \file
/// Definition of the Diligent::IBufferGL interface

import bindbc.diligent.graphics.buffer;

// {08DF7319-F425-4EC7-8D2B-1B3FC0BDDBB4}
static const INTERFACE_ID IID_BufferGL =
    INTERFACE_ID(0x8df7319, 0xf425, 0x4ec7, [0x8d, 0x2b, 0x1b, 0x3f, 0xc0, 0xbd, 0xdb, 0xb4]);

/// Exposes OpenGL-specific functionality of a buffer object.
struct IBufferGLMethods
{
    /// Returns OpenGL buffer handle
    GLuint* GetGLBufferHandle(IBufferGL*);
}

struct IBufferGLVtbl { IBufferGLMethods BufferGL; }
struct IBufferGL { IBufferGLVtbl* pVtbl; }

GLuint* IBufferGL_GetGLBufferHandle(IBufferGL* buffer) {
    return buffer.pVtbl.BufferGL.GetGLBufferHandle(buffer);
}