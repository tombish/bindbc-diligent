/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Primitives/interface/DebugOutput.h
 *  The original licence follows this statement
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

module bindbc.diligent.primitives.debugoutput;

/// Describes debug message severity
enum DEBUG_MESSAGE_SEVERITY
{
    /// Information message
    DEBUG_MESSAGE_SEVERITY_INFO = 0,

    /// Warning message
    DEBUG_MESSAGE_SEVERITY_WARNING,

    /// Error, with potential recovery
    DEBUG_MESSAGE_SEVERITY_ERROR,

    /// Fatal error - recovery is not possible
    DEBUG_MESSAGE_SEVERITY_FATAL_ERROR
}


/// Type of the debug message callback function

/// \param [in] Severity - Message severity
/// \param [in] Message - Debug message
/// \param [in] Function - Name of the function or nullptr
/// \param [in] Function - File name or nullptr
/// \param [in] Line - Line number
alias DebugMessageCallbackType = void function(DEBUG_MESSAGE_SEVERITY Severity, const(char)* Message, const(char)* Function, const(char)* File, int Line);
extern DebugMessageCallbackType DebugMessageCallback;


/// Sets the debug message callback function

/// \note This function needs to be called for every executable module that
///       wants to use the callback.
void SetDebugMessageCallback(DebugMessageCallbackType DbgMessageCallback);
